#!/usr/bin/env python3
"""EEN Customer Impact Health — local dashboard with team breakdown."""

import os, re
from flask import Flask, jsonify, render_template
from datetime import datetime, timezone, timedelta
from collections import defaultdict

from jira_client import jira_search, fmt_issue, _extract_adf_text, BASE
from queries import CI_BASE, VMSSUP_JQL, VMSSUP_COLUMNS, CI_HIST_BASE, FIELDS_FULL, FIELDS_SHORT
from themes import classify_theme

app = Flask(__name__)

AGE_BUCKETS = [
    ("< 1 week",   0,   7),
    ("1–2 weeks",  7,   14),
    ("2–4 weeks",  14,  28),
    ("1–3 months", 28,  90),
    ("3–6 months", 90,  180),
    ("6+ months",  180, 99999),
]


@app.route('/api/data')
def api_data():
    now = datetime.now(timezone.utc)
    all_issues = jira_search(CI_BASE, FIELDS_FULL)

    prio_counts      = defaultdict(int)
    team_data        = defaultdict(lambda: {'total': 0, 'highest': 0, 'high': 0, 'medium': 0})
    assignee_load    = defaultdict(lambda: {'ci': 0, 'ci_highest': 0, 'ci_high': 0})
    assignee_tickets = defaultdict(list)
    acct_data        = defaultdict(lambda: {'total': 0, 'high': 0, 'medium': 0})

    for issue in all_issues:
        f        = issue['fields']
        prio     = (f.get('priority') or {}).get('name', 'Medium')
        team     = (f.get('customfield_10500') or {}).get('name', 'Unassigned')
        assignee = (f.get('assignee') or {}).get('displayName', 'Unassigned')

        prio_counts[prio] += 1
        team_data[team]['total'] += 1
        if prio == 'Highest':    team_data[team]['highest'] += 1
        elif prio == 'High':     team_data[team]['high'] += 1
        else:                    team_data[team]['medium'] += 1

        assignee_load[assignee]['ci'] += 1
        if prio == 'Highest':   assignee_load[assignee]['ci_highest'] += 1
        elif prio == 'High':    assignee_load[assignee]['ci_high'] += 1
        assignee_tickets[assignee].append(fmt_issue(issue, now))

        acct_raw = f.get('customfield_11063')
        acct_name = (acct_raw.get('value') or acct_raw.get('name') or '') if isinstance(acct_raw, dict) else (str(acct_raw).strip() if acct_raw else '')
        if not acct_name:
            desc_text = _extract_adf_text(f.get('description') or {})
            m = re.search(r'(?:Master\s+)?Account:\s*\d+\s*[-–]\s*(.+)', desc_text, re.IGNORECASE)
            if m:
                acct_name = m.group(1).strip().split('\n')[0].strip()
        bucket = acct_name if acct_name else '__unattributed__'
        acct_data[bucket]['total'] += 1
        if prio in ('Highest', 'High'): acct_data[bucket]['high'] += 1
        else:                           acct_data[bucket]['medium'] += 1

    age_dist     = {lbl: {'total': 0, 'high': 0, 'medium': 0} for lbl, _, _ in AGE_BUCKETS}
    three_days   = (now + timedelta(days=3)).date()
    due_soon     = []
    punted       = []
    never_sprint = []
    out_of_spec  = []

    for issue in all_issues:
        f     = issue['fields']
        prio  = (f.get('priority') or {}).get('name', 'Medium')
        fmted = fmt_issue(issue, now)
        age   = fmted['age_days']

        for lbl, lo, hi in AGE_BUCKETS:
            if lo <= age < hi:
                age_dist[lbl]['total'] += 1
                if prio in ('Highest', 'High'): age_dist[lbl]['high'] += 1
                else:                           age_dist[lbl]['medium'] += 1
                break

        if (prio == 'Highest' and age > 7) or (prio == 'High' and age > 14) or (age > 28):
            out_of_spec.append(fmted)

        dd = f.get('duedate')
        if dd and dd <= str(three_days):
            due_soon.append(fmted)
        if 'repeatedly-punted' in (f.get('labels') or []):
            punted.append(fmted)
        if not f.get('customfield_10007'):
            never_sprint.append(fmted)

    out_of_spec.sort(key=lambda x: ({'Highest': 0, 'High': 1}.get(x['priority'], 2), -x['age_days']))
    never_sprint.sort(key=lambda x: x['age_days'], reverse=True)
    teams_sorted = sorted(team_data.items(), key=lambda x: -x[1]['total'])

    teams_tickets   = defaultdict(list)
    account_tickets = defaultdict(list)
    theme_tickets   = defaultdict(list)

    for issue in all_issues:
        f     = issue['fields']
        team  = (f.get('customfield_10500') or {}).get('name', 'Unassigned')
        fmted = fmt_issue(issue, now)
        teams_tickets[team].append(fmted)
        theme_tickets[classify_theme(f.get('summary', ''))].append(fmted)

        acct_raw = f.get('customfield_11063')
        acct_key = (acct_raw.get('value') or acct_raw.get('name') or '') if isinstance(acct_raw, dict) else (str(acct_raw).strip() if acct_raw else '')
        if not acct_key:
            desc_text = _extract_adf_text(f.get('description') or {})
            m = re.search(r'(?:Master\s+)?Account:\s*\d+\s*[-–]\s*(.+)', desc_text, re.IGNORECASE)
            if m:
                acct_key = m.group(1).strip().split('\n')[0].strip()
        account_tickets[acct_key or '__none__'].append(fmted)

    return jsonify({
        'total':               len(all_issues),
        'prio_counts':         dict(prio_counts),
        'teams':               [{'name': k, **v} for k, v in teams_sorted],
        'teams_tickets':       {k: sorted(v, key=lambda x: -x['age_days']) for k, v in teams_tickets.items()},
        'account_tickets':     {k: sorted(v, key=lambda x: -x['age_days']) for k, v in account_tickets.items()},
        'themes':              sorted([{'label': k, 'count': len(v)} for k, v in theme_tickets.items()], key=lambda x: -x['count']),
        'theme_tickets':       {k: sorted(v, key=lambda x: -x['age_days']) for k, v in theme_tickets.items()},
        'age_dist':            [{'label': lbl, **age_dist[lbl]} for lbl, _, _ in AGE_BUCKETS],
        'out_of_spec':         out_of_spec,
        'due_soon':            sorted(due_soon, key=lambda x: x['duedate']),
        'punted':              punted,
        'never_sprint':        never_sprint,
        'assignee_load':       sorted([{'name': k, **v} for k, v in assignee_load.items()], key=lambda x: -x['ci']),
        'assignee_tickets':    {k: v for k, v in assignee_tickets.items()},
        'account_heat':        sorted([{'account': k, **v} for k, v in acct_data.items() if k != '__unattributed__'], key=lambda x: -x['total'])[:15],
        'account_attributed':  {
            'total':  sum(v['total']  for k, v in acct_data.items() if k != '__unattributed__'),
            'high':   sum(v['high']   for k, v in acct_data.items() if k != '__unattributed__'),
            'medium': sum(v['medium'] for k, v in acct_data.items() if k != '__unattributed__'),
        },
        'account_unattributed': dict(acct_data.get('__unattributed__', {'total': 0, 'high': 0, 'medium': 0})),
        'refreshed_at':         now.isoformat(),
    })


@app.route('/api/vmssup')
def api_vmssup():
    now    = datetime.now(timezone.utc)
    fields = ['summary', 'status', 'priority', 'assignee', 'created', 'updated']
    issues = jira_search(VMSSUP_JQL, fields, max_results=200)

    status_to_col = {s: col for col, statuses in VMSSUP_COLUMNS for s in statuses}
    DISPLAY_COLS  = [col for col, _ in VMSSUP_COLUMNS if col != 'Backlog']
    PRIO_ORDER    = {'Highest': 0, 'High': 1, 'Medium': 2}

    prio_counts   = defaultdict(int)
    assignee_grid = defaultdict(lambda: {c: [] for c in DISPLAY_COLS})
    all_tickets   = []

    for i in issues:
        f       = i['fields']
        prio    = (f.get('priority') or {}).get('name', 'Medium')
        created = datetime.fromisoformat(f['created'].replace('Z', '+00:00'))
        updated = datetime.fromisoformat(f['updated'].replace('Z', '+00:00'))
        t = {
            'key':        i['key'],
            'summary':    f.get('summary', ''),
            'status':     (f.get('status') or {}).get('name', ''),
            'priority':   prio,
            'assignee':   (f.get('assignee') or {}).get('displayName', 'Unassigned'),
            'age_days':   (now - created).days,
            'stale_days': (now - updated).days,
            'url':        f'{BASE}/browse/{i["key"]}',
        }
        prio_counts[prio] += 1
        all_tickets.append(t)
        col = status_to_col.get(t['status'])
        if col and col in DISPLAY_COLS:
            assignee_grid[t['assignee']][col].append(t)

    assignees = []
    for name in sorted(assignee_grid):
        cols  = {}
        total = 0
        for col in DISPLAY_COLS:
            tickets = sorted(assignee_grid[name][col], key=lambda x: (PRIO_ORDER.get(x['priority'], 3), x['status']))
            cols[col] = tickets
            total    += len(tickets)
        assignees.append({'name': name, 'total': total, 'columns': cols})

    stalled = [t for t in all_tickets if t['stale_days'] >= 3 and t['priority'] in ('Highest', 'High')]
    stalled.sort(key=lambda x: (x['priority'] != 'Highest', -x['stale_days']))

    return jsonify({
        'total':        len(issues),
        'prio_counts':  dict(prio_counts),
        'assignees':    assignees,
        'display_cols': DISPLAY_COLS,
        'stalled':      stalled,
        'refreshed_at': now.isoformat(),
    })


@app.route('/api/pipeline')
def api_pipeline():
    now    = datetime.now(timezone.utc)
    issues = jira_search(
        '((project = VMSSUP AND NOT (description ~ "task id" AND reporter in (604fb2f681b82500682d022a))) '
        'OR (project in (EEPD, Infrastructure) AND labels in (customer-impact))) '
        'AND status in ("Engineering Work", "Support Review", "Validation") '
        'AND statusCategory != Done '
        'AND issuetype not in (Improvement, story) '
        'AND priority not in (Low, Lowest) '
        'ORDER BY updated ASC',
        ['summary', 'status', 'priority', 'assignee', 'updated', 'created', 'project'],
        max_results=100
    )
    tickets = []
    for i in issues:
        f       = i['fields']
        created = datetime.fromisoformat(f['created'].replace('Z', '+00:00'))
        updated = datetime.fromisoformat(f['updated'].replace('Z', '+00:00'))
        tickets.append({
            'key':        i['key'],
            'summary':    f.get('summary', ''),
            'status':     f['status']['name'],
            'priority':   (f.get('priority') or {}).get('name', '?'),
            'assignee':   (f.get('assignee') or {}).get('displayName', 'Unassigned'),
            'age_days':   (now - created).days,
            'stale_days': (now - updated).days,
            'project':    f['project']['key'],
        })
    by_status = {}
    for t in tickets:
        by_status.setdefault(t['status'], []).append(t)
    return jsonify({'by_status': by_status, 'total': len(tickets), 'refreshed_at': now.isoformat()})


@app.route('/api/reporting')
def api_reporting():
    now    = datetime.now(timezone.utc)
    opened = jira_search(CI_HIST_BASE + ' AND created >= -28d', ['created'], max_results=200)
    closed_issues = jira_search(
        CI_HIST_BASE + ' AND statusCategory in (Done) AND resolved >= -28d',
        ['resolutiondate'], max_results=200
    )
    weeks = []
    for w in range(3, -1, -1):
        end_dt  = now - timedelta(days=w * 7)
        start_dt = now - timedelta(days=(w + 1) * 7)
        end_d   = end_dt.date()
        start_d = start_dt.date()
        label   = f'{start_d.strftime("%-m/%-d")}–{end_d.strftime("%-m/%-d")}'
        o = sum(1 for i in opened
                if start_d <= datetime.fromisoformat(i['fields']['created'].replace('Z', '+00:00')).date() < end_d)
        c = sum(1 for i in closed_issues
                if i['fields'].get('resolutiondate') and
                start_d <= datetime.fromisoformat(i['fields']['resolutiondate'].replace('Z', '+00:00')).date() < end_d)
        weeks.append({'label': label, 'opened': o, 'closed': c})
    return jsonify({'throughput_weeks': weeks, 'refreshed_at': now.isoformat()})


@app.route('/')
def index():
    return render_template('dashboard.html')


if __name__ == '__main__':
    port = int(os.environ.get('CI_DASH_PORT', 8081))
    print(f'\n  Customer Impact Health → http://localhost:{port}\n')
    app.run(host='127.0.0.1', port=port, debug=False, threaded=True)
