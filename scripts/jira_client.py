"""Low-level JIRA helpers: credentials, search, issue formatting."""

import os, json, subprocess
from datetime import datetime

BASE = 'https://eagleeyenetworks.atlassian.net'


def _load_env():
    result = subprocess.run(
        ['zsh', '-c', 'source ~/.zshrc 2>/dev/null && env'],
        capture_output=True, text=True
    )
    for line in result.stdout.splitlines():
        if '=' in line:
            k, _, v = line.partition('=')
            if k in ('JIRA_EMAIL', 'JIRA_API_TOKEN') and not os.environ.get(k):
                os.environ[k] = v

_load_env()

EMAIL = os.environ.get('JIRA_EMAIL', '')
TOKEN = os.environ.get('JIRA_API_TOKEN', '')


def _extract_adf_text(content):
    if isinstance(content, str): return content
    if isinstance(content, dict):
        if content.get('type') == 'text': return content.get('text', '')
        if content.get('type') == 'hardBreak': return '\n'
        if 'content' in content: return _extract_adf_text(content['content'])
    if isinstance(content, list): return ''.join(_extract_adf_text(i) for i in content)
    return ''


def jira_search(jql, fields, max_results=100):
    issues, next_token = [], None
    while True:
        body = {'jql': jql, 'maxResults': max_results, 'fields': fields}
        if next_token:
            body['nextPageToken'] = next_token
        r = subprocess.run(
            ['curl', '-s', '-u', f'{EMAIL}:{TOKEN}',
             '-X', 'POST', f'{BASE}/rest/api/3/search/jql',
             '-H', 'Content-Type: application/json',
             '-d', json.dumps(body)],
            capture_output=True, text=True
        )
        d = json.loads(r.stdout)
        batch = d.get('issues', d.get('values', []))
        issues.extend(batch)
        next_token = d.get('nextPageToken')
        if not next_token or not batch:
            break
    return issues


def fmt_issue(i, now):
    f = i['fields']
    created = datetime.fromisoformat(f['created'].replace('Z', '+00:00'))
    age = (now - created).days
    sprints = f.get('customfield_10007') or f.get('sprint') or []
    if not isinstance(sprints, list): sprints = [sprints] if sprints else []
    return {
        'key':          i['key'],
        'summary':      f.get('summary', ''),
        'status':       (f.get('status') or {}).get('name', ''),
        'priority':     (f.get('priority') or {}).get('name', ''),
        'assignee':     (f.get('assignee') or {}).get('displayName', 'Unassigned'),
        'duedate':      f.get('duedate') or '',
        'project':      (f.get('project') or {}).get('key', ''),
        'age_days':     age,
        'created_date': created.strftime('%Y-%m-%d'),
        'url':          f'{BASE}/browse/{i["key"]}',
        'sprint_count': len(sprints),
    }
