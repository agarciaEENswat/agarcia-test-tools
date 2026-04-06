#!/usr/bin/env python3
"""
jira-account-backfill.py

Finds open customer-impact CI tickets where the account custom fields are empty,
parses account info from the description text, and (optionally) writes it back
to the JIRA fields.

Usage:
    python3 scripts/jira-account-backfill.py              # dry run (default)
    python3 scripts/jira-account-backfill.py --write      # actually update JIRA

Requires env vars: JIRA_EMAIL, JIRA_API_TOKEN
"""

import os, json, re, subprocess, sys
from datetime import datetime, timezone

BASE        = 'https://eagleeyenetworks.atlassian.net'
EMAIL       = os.environ.get('JIRA_EMAIL', '')
TOKEN       = os.environ.get('JIRA_API_TOKEN', '')
DRY_RUN     = '--write' not in sys.argv

# CI tickets where account field is missing
JQL = (
    '((project = EENS AND reporter not in (604fb2f681b82500682d022a)) '
    'OR (project in (EEPD, Infrastructure) AND labels in (customer-impact))) '
    'AND issuetype not in (Improvement, story) '
    'AND statusCategory not in (Done) '
    'AND priority not in (Low, Lowest) '
    'AND customfield_11063 is EMPTY'
)

FIELDS = ['summary', 'priority', 'project', 'description',
          'customfield_11063', 'customfield_10988',
          'customfield_11064', 'customfield_10987']


def _extract_adf_text(content):
    if isinstance(content, str): return content
    if isinstance(content, dict):
        if content.get('type') == 'text': return content.get('text', '')
        if content.get('type') == 'hardBreak': return '\n'
        if content.get('type') == 'paragraph':
            return _extract_adf_text(content.get('content', [])) + '\n'
        if 'content' in content: return _extract_adf_text(content['content'])
    if isinstance(content, list): return ''.join(_extract_adf_text(i) for i in content)
    return ''


def jira_search(jql, fields, max_results=200):
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


def jira_update(key, fields_dict):
    body = {'fields': fields_dict}
    r = subprocess.run(
        ['curl', '-s', '-o', '/dev/null', '-w', '%{http_code}',
         '-u', f'{EMAIL}:{TOKEN}',
         '-X', 'PUT', f'{BASE}/rest/api/3/issue/{key}',
         '-H', 'Content-Type: application/json',
         '-d', json.dumps(body)],
        capture_output=True, text=True
    )
    return r.stdout.strip()


def parse_account_from_description(desc_text):
    """
    Returns dict with any of: acct_id, acct_name, sub_id, sub_name
    Handles patterns like:
      Account: 00024921 - Ajartec Ltd
      Subaccount: 00170369 - Trinity College London
      Master Account: 00024921 - Ajartec
    """
    result = {}

    # Master account
    m = re.search(
        r'(?:Master\s+)?Account[:\s]+(\d{8})\s*[-–]\s*([^\n\r]+)',
        desc_text, re.IGNORECASE
    )
    if m:
        result['acct_id']   = m.group(1).strip()
        result['acct_name'] = m.group(2).strip()

    # Sub-account
    m2 = re.search(
        r'Sub[-\s]?[Aa]ccount[:\s]+(\d{8})\s*[-–]\s*([^\n\r]+)',
        desc_text, re.IGNORECASE
    )
    if m2:
        result['sub_id']   = m2.group(1).strip()
        result['sub_name'] = m2.group(2).strip()

    return result


def main():
    if not EMAIL or not TOKEN:
        print('ERROR: JIRA_EMAIL and JIRA_API_TOKEN must be set.')
        sys.exit(1)

    print(f'Mode: {"DRY RUN" if DRY_RUN else "WRITE"}\n')
    print('Fetching CI tickets with empty account fields...')
    issues = jira_search(JQL, FIELDS)
    print(f'Found {len(issues)} tickets with missing account info.\n')

    parseable   = []
    unparseable = []

    for issue in issues:
        key  = issue['key']
        f    = issue['fields']
        prio = (f.get('priority') or {}).get('name', '?')
        summ = f.get('summary', '')[:70]
        desc_text = _extract_adf_text(f.get('description') or {})
        parsed = parse_account_from_description(desc_text)

        if parsed:
            parseable.append((key, prio, summ, parsed))
        else:
            unparseable.append((key, prio, summ))

    # --- Report: what we can fill in ---
    print(f'{"="*70}')
    print(f'  PARSEABLE: {len(parseable)} tickets — account info found in description')
    print(f'{"="*70}\n')

    for key, prio, summ, parsed in parseable:
        print(f'  [{prio:8s}] {key}  {summ}')
        if 'acct_id' in parsed:
            print(f'             Master Account : {parsed["acct_id"]} — {parsed.get("acct_name","?")}')
        if 'sub_id' in parsed:
            print(f'             Sub-account    : {parsed["sub_id"]} — {parsed.get("sub_name","?")}')
        print()

    # --- Report: what we can't fill in ---
    print(f'{"="*70}')
    print(f'  UNPARSEABLE: {len(unparseable)} tickets — no account pattern found in description')
    print(f'{"="*70}\n')
    for key, prio, summ in unparseable:
        print(f'  [{prio:8s}] {key}  {summ}')

    if DRY_RUN:
        print(f'\nDry run complete. Run with --write to update {len(parseable)} tickets.')
        return

    # --- Write mode ---
    print(f'\nWriting {len(parseable)} tickets...\n')
    ok = fail = 0
    for key, prio, summ, parsed in parseable:
        fields_to_write = {}
        if 'acct_name' in parsed: fields_to_write['customfield_11063'] = parsed['acct_name']
        if 'acct_id'   in parsed: fields_to_write['customfield_10988'] = parsed['acct_id']
        if 'sub_name'  in parsed: fields_to_write['customfield_11064'] = parsed['sub_name']
        if 'sub_id'    in parsed: fields_to_write['customfield_10987'] = parsed['sub_id']

        status = jira_update(key, fields_to_write)
        if status == '204':
            print(f'  OK     {key}')
            ok += 1
        else:
            print(f'  FAIL   {key}  (HTTP {status})')
            fail += 1

    print(f'\nDone. {ok} updated, {fail} failed.')


if __name__ == '__main__':
    main()
