"""JQL queries and field lists for the CI dashboard."""

CI_BASE = (
    '((project = EENS AND reporter not in (604fb2f681b82500682d022a)) '
    'OR (project in (EEPD, Infrastructure) AND labels in (customer-impact))) '
    'AND issuetype not in (Improvement, story) '
    'AND statusCategory not in (Done) '
    'AND priority not in (Low, Lowest)'
)

VMSSUP_JQL = (
    'project = VMSSUP '
    'AND statusCategory not in (Done) '
    'AND NOT (description ~ "task id" AND reporter in (604fb2f681b82500682d022a))'
)

# Board column → status names
VMSSUP_COLUMNS = [
    ("Backlog",            ["Backlog"]),
    ("Assistance / To-Do", ["Assistance", "Support Assistance"]),
    ("Triage",             ["Triaging"]),
    ("Engineering",        ["Investigation", "Engineering Work", "Infrastructure Work", "In Progress"]),
    ("Support Review",     ["Support Review", "Resolved Review"]),
]

CI_HIST_BASE = (
    '((project = EENS AND reporter not in (604fb2f681b82500682d022a)) '
    'OR (project in (EEPD, Infrastructure) AND labels in (customer-impact))) '
    'AND issuetype not in (Improvement, story) '
    'AND priority not in (Low, Lowest)'
)

FIELDS_FULL = [
    'summary', 'status', 'priority', 'assignee', 'duedate', 'labels',
    'customfield_10500', 'created', 'project', 'sprint', 'customfield_11063',
    'description', 'customfield_10007',
]

FIELDS_SHORT = ['summary', 'status', 'priority', 'assignee', 'duedate', 'project', 'created']
