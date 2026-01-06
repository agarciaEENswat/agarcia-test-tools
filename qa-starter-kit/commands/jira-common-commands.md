# Common Jira API Commands

Quick reference for common Jira operations via API. All commands use your stored credentials from environment variables.

## Prerequisites

Make sure you've set up your Jira credentials (see `jira-setup-instructions.md`):
```bash
export JIRA_URL="https://your-company.atlassian.net"
export JIRA_EMAIL="your-email@company.com"
export JIRA_API_TOKEN="your-token"
```

---

## Quick Commands

### Get Your Info
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X GET "${JIRA_URL}/rest/api/3/myself"
```

### Get Your Assigned Tickets
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "assignee=currentUser() AND resolution=Unresolved ORDER BY updated DESC",
    "fields": ["key", "summary", "status", "priority"],
    "maxResults": 50
  }'
```

### Get Your Open QA Tickets
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "assignee=currentUser() AND summary ~ \"QA_\" AND resolution=Unresolved",
    "fields": ["key", "summary", "status", "priority"],
    "maxResults": 50
  }'
```

---

## Searching Tickets

### Search by Project
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "project=EEPD ORDER BY created DESC",
    "maxResults": 20
  }'
```

### Search by Label
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "labels=YourLabel AND resolution=Unresolved",
    "maxResults": 50
  }'
```

### Search for Bugs You Filed
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "reporter=currentUser() AND issuetype=Bug ORDER BY created DESC",
    "maxResults": 50
  }'
```

### Search by Text
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "text ~ \"search term\" ORDER BY updated DESC",
    "maxResults": 20
  }'
```

### Get Recently Updated Tickets
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "project=EEPD AND updated >= -7d ORDER BY updated DESC",
    "maxResults": 50
  }'
```

---

## Reading Ticket Details

### Get Specific Ticket
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X GET "${JIRA_URL}/rest/api/3/issue/EEPD-12345"
```

### Get Ticket with Specific Fields Only
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X GET "${JIRA_URL}/rest/api/3/issue/EEPD-12345?fields=summary,status,assignee,description"
```

### Get Ticket Comments
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X GET "${JIRA_URL}/rest/api/3/issue/EEPD-12345/comment"
```

### Get Ticket Subtasks
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X GET "${JIRA_URL}/rest/api/3/issue/EEPD-12345?fields=subtasks"
```

### Get Linked Issues
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X GET "${JIRA_URL}/rest/api/3/issue/EEPD-12345?fields=issuelinks"
```

---

## Creating & Updating Tickets

### Add Comment to Ticket
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/issue/EEPD-12345/comment" \
  -H "Content-Type: application/json" \
  -d '{
    "body": {
      "type": "doc",
      "version": 1,
      "content": [
        {
          "type": "paragraph",
          "content": [
            {
              "type": "text",
              "text": "Your comment text here"
            }
          ]
        }
      ]
    }
  }'
```

### Create a Bug
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/issue" \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "project": {
        "key": "EEPD"
      },
      "issuetype": {
        "name": "Bug"
      },
      "summary": "QA_WebUI - Brief description of bug",
      "priority": {
        "name": "High"
      },
      "description": {
        "type": "doc",
        "version": 1,
        "content": [
          {
            "type": "paragraph",
            "content": [
              {
                "type": "text",
                "text": "Bug description here"
              }
            ]
          }
        ]
      },
      "labels": ["QA", "WebUI"]
    }
  }'
```

### Create a Story
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/issue" \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "project": {
        "key": "EEPD"
      },
      "issuetype": {
        "name": "Story"
      },
      "summary": "QA_Story title here",
      "priority": {
        "name": "Medium"
      }
    }
  }'
```

### Update Ticket Status (Transition)
First get available transitions:
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X GET "${JIRA_URL}/rest/api/3/issue/EEPD-12345/transitions"
```

Then transition (example: Close ticket):
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/issue/EEPD-12345/transitions" \
  -H "Content-Type: application/json" \
  -d '{
    "transition": {
      "id": "211"
    }
  }'
```

### Update Ticket Fields
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X PUT "${JIRA_URL}/rest/api/3/issue/EEPD-12345" \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "labels": ["QA", "Testing"]
    }
  }'
```

---

## Review Period Queries - "What You Made"

Focus on what you **created/reported** or **worked on**, not what you closed.

**Note**: "Quarter" here means any 90-day review period, not necessarily calendar quarters.

### All QA Bugs You Filed This Quarter
```bash
# Q4 2025 example (Oct-Dec)
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "reporter=currentUser() AND issuetype=Bug AND summary ~ \"QA_\" AND created >= 2025-10-01 AND created <= 2025-12-31 ORDER BY created DESC",
    "fields": ["key", "summary", "status", "priority", "created"],
    "maxResults": 200
  }'
```

### All Stories/Tickets You Created This Quarter
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "reporter=currentUser() AND created >= 2025-10-01 AND created <= 2025-12-31 ORDER BY created DESC",
    "fields": ["key", "summary", "issuetype", "status", "created"],
    "maxResults": 200
  }'
```

### Count Bugs Filed by Severity This Quarter
```bash
# Get all bugs, then count manually or pipe through counter
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "reporter=currentUser() AND issuetype=Bug AND created >= 2025-10-01 ORDER BY priority",
    "fields": ["key", "summary", "priority"],
    "maxResults": 200
  }'
```

### Test Plans Created This Quarter (Confluence)
```bash
# Search Confluence for test plans you created
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X GET "${JIRA_URL}/wiki/api/v2/pages?spaceId=3964929&limit=50" \
  | python3 -c "import sys, json; data=json.load(sys.stdin); [print(f\"{p['id']}: {p['title']}\") for p in data.get('results', []) if 'QA Test Plan' in p.get('title', '')]"
```

### Tickets You Were Assigned This Quarter
```bash
# Shows what work was given to you
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "assignee=currentUser() AND created >= 2025-10-01 ORDER BY created DESC",
    "maxResults": 200
  }'
```

### Tickets You Worked On (Last 90 Days)
```bash
# Shows tickets you created, were assigned to, or commented on
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "(reporter=currentUser() OR assignee=currentUser() OR comment ~ currentUser()) AND updated >= -90d ORDER BY updated DESC",
    "fields": ["key", "summary", "issuetype", "status", "updated"],
    "maxResults": 200
  }'
```

### Get Tickets by Date Range

**Last 90 days**:
```jql
updated >= -90d
```

**Specific date range (any 90-day period)**:
```jql
created >= 2025-09-15 AND created <= 2025-12-15
```

**Calendar quarter examples (if your company uses these)**:
```jql
# Q1 (Jan-Mar)
created >= 2025-01-01 AND created <= 2025-03-31

# Q2 (Apr-Jun)
created >= 2025-04-01 AND created <= 2025-06-30

# Q3 (Jul-Sep)
created >= 2025-07-01 AND created <= 2025-09-30

# Q4 (Oct-Dec)
created >= 2025-10-01 AND created <= 2025-12-31
```

---

## Useful JQL Filters

### High Priority Items Assigned to You
```jql
assignee=currentUser() AND priority in (Highest, High) AND resolution=Unresolved
```

### Bugs You Reported That Are Still Open
```jql
reporter=currentUser() AND issuetype=Bug AND resolution=Unresolved
```

### QA Tickets Created Last Week
```jql
summary ~ "QA_" AND created >= -7d
```

### Tickets Updated Today
```jql
project=EEPD AND updated >= startOfDay()
```

### Your Tickets Due This Week
```jql
assignee=currentUser() AND duedate <= endOfWeek() AND resolution=Unresolved
```

### Tickets You Created This Month
```jql
reporter=currentUser() AND created >= startOfMonth()
```

### Bugs You Filed This Month
```jql
reporter=currentUser() AND issuetype=Bug AND created >= startOfMonth()
```

---

## Helper Scripts

### Pretty Print JSON Output
```bash
| python3 -m json.tool
```

### Extract Just Ticket Keys
```bash
| python3 -c "import sys, json; data=json.load(sys.stdin); print('\n'.join([i['key'] for i in data['issues']]))"
```

### Count Results
```bash
| python3 -c "import sys, json; print(json.load(sys.stdin)['total'])"
```

### Extract Summary and Key
```bash
| python3 -c "import sys, json; data=json.load(sys.stdin); [print(f\"{i['key']}: {i['fields']['summary']}\") for i in data['issues']]"
```

### Group by Priority
```bash
| python3 -c "import sys, json; data=json.load(sys.stdin); priorities={}; [priorities.setdefault(i['fields']['priority']['name'], []).append(i['key']) for i in data['issues']]; [print(f\"{p}: {len(tickets)} tickets\") for p, tickets in priorities.items()]"
```

---

## Bash Aliases

Add these to `~/.bashrc` for quick access:

```bash
# Get my open tickets
alias jira-my-tickets='curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" -X POST "${JIRA_URL}/rest/api/3/search/jql" -H "Content-Type: application/json" -d '"'"'{"jql": "assignee=currentUser() AND resolution=Unresolved", "maxResults": 50}'"'"' | python3 -m json.tool'

# Get ticket by key
jira-get() {
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X GET "${JIRA_URL}/rest/api/3/issue/$1" | python3 -m json.tool
}

# Add comment to ticket
jira-comment() {
  local ticket=$1
  local comment=$2
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/issue/${ticket}/comment" \
    -H "Content-Type: application/json" \
    -d "{\"body\":{\"type\":\"doc\",\"version\":1,\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"${comment}\"}]}]}}"
}

# Get bugs filed this quarter
jira-bugs-filed() {
  local start_date=$1  # Format: YYYY-MM-DD
  local end_date=$2
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/search/jql" \
    -H "Content-Type: application/json" \
    -d "{\"jql\": \"reporter=currentUser() AND issuetype=Bug AND created >= ${start_date} AND created <= ${end_date}\", \"maxResults\": 200}" \
    | python3 -m json.tool
}

# Get tickets created this quarter
jira-created-quarterly() {
  local start_date=$1
  local end_date=$2
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/search/jql" \
    -H "Content-Type: application/json" \
    -d "{\"jql\": \"reporter=currentUser() AND created >= ${start_date} AND created <= ${end_date}\", \"fields\": [\"key\", \"summary\", \"issuetype\", \"created\"], \"maxResults\": 200}" \
    | python3 -m json.tool
}

# Get bugs filed in last 90 days
jira-bugs-filed-90days() {
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/search/jql" \
    -H "Content-Type: application/json" \
    -d '{"jql": "reporter=currentUser() AND issuetype=Bug AND created >= -90d ORDER BY created DESC", "fields": ["key", "summary", "status", "priority", "created"], "maxResults": 200}' \
    | python3 -m json.tool
}

# Get tickets created in last 90 days
jira-created-90days() {
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/search/jql" \
    -H "Content-Type: application/json" \
    -d '{"jql": "reporter=currentUser() AND created >= -90d ORDER BY created DESC", "fields": ["key", "summary", "issuetype", "status", "created"], "maxResults": 200}' \
    | python3 -m json.tool
}

# Get tickets you worked on in last 90 days (created, assigned, or commented)
jira-worked-90days() {
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/search/jql" \
    -H "Content-Type: application/json" \
    -d '{"jql": "(reporter=currentUser() OR assignee=currentUser() OR comment ~ currentUser()) AND updated >= -90d ORDER BY updated DESC", "fields": ["key", "summary", "issuetype", "status", "updated"], "maxResults": 200}' \
    | python3 -m json.tool
}
```

Usage:
```bash
# Daily commands
jira-my-tickets
jira-get EEPD-12345
jira-comment EEPD-12345 "Testing complete"

# Review period commands (90 days)
jira-bugs-filed-90days
jira-created-90days
jira-worked-90days

# Specific date range
jira-bugs-filed 2025-09-15 2025-12-15
jira-created-quarterly 2025-09-15 2025-12-15
```

---

## Quick Reference

### Common Fields
- `key` - Ticket ID
- `summary` - Title
- `description` - Full description
- `status` - Current status
- `priority` - Priority level
- `assignee` - Assigned to
- `reporter` - Created by
- `created` - Creation date
- `updated` - Last update
- `resolved` - Resolution date
- `labels` - Tags
- `issuetype` - Type (Bug, Story, etc.)

### JQL Date Keywords
- `startOfDay()` - Today start
- `endOfDay()` - Today end
- `startOfWeek()` - Week start
- `endOfWeek()` - Week end
- `startOfMonth()` - Month start
- `endOfMonth()` - Month end
- `startOfYear()` - Year start
- `-7d` - 7 days ago
- `-30d` - 30 days ago

### Pro Tips
- Use `maxResults: 200` for quarterly reviews
- Use `created >=` to find what you made
- Use `reporter=currentUser()` for your tickets
- Group by `issuetype` to categorize work
- Export to JSON, process with python for reports
