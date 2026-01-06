#!/bin/bash

# QA Toolbox Setup Script
# This script installs Jira helper functions to your .bashrc

echo "=================================================="
echo "QA Toolbox Setup"
echo "=================================================="
echo ""

# Check if Jira credentials are already set
if grep -q "# Jira Configuration" ~/.bashrc; then
    echo "✓ Jira configuration already exists in .bashrc"
    read -p "Do you want to update it? (y/n): " update_creds
    if [ "$update_creds" != "y" ]; then
        echo "Skipping Jira credentials..."
    else
        echo ""
        echo "Please enter your Jira credentials:"
        read -p "Jira URL [https://eagleeyenetworks.atlassian.net]: " JIRA_URL
        JIRA_URL=${JIRA_URL:-https://eagleeyenetworks.atlassian.net}

        read -p "Jira Email: " JIRA_EMAIL
        read -p "Jira API Token: " JIRA_API_TOKEN

        # Remove old Jira configuration
        # macOS requires empty string for -i flag
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' '/# Jira Configuration/,/^$/d' ~/.bashrc
        else
            sed -i '/# Jira Configuration/,/^$/d' ~/.bashrc
        fi

        # Add new Jira configuration
        cat >> ~/.bashrc << EOF

# Jira Configuration
export JIRA_URL="${JIRA_URL}"
export JIRA_EMAIL="${JIRA_EMAIL}"
export JIRA_API_TOKEN="${JIRA_API_TOKEN}"
EOF
        echo "✓ Jira credentials updated in .bashrc"
    fi
else
    echo "Setting up Jira credentials..."
    echo ""
    echo "Please enter your Jira credentials:"
    echo "(See setup/jira-setup-instructions.md for how to get your API token)"
    echo ""
    read -p "Jira URL [https://eagleeyenetworks.atlassian.net]: " JIRA_URL
    JIRA_URL=${JIRA_URL:-https://eagleeyenetworks.atlassian.net}

    read -p "Jira Email: " JIRA_EMAIL
    read -p "Jira API Token: " JIRA_API_TOKEN

    cat >> ~/.bashrc << EOF

# Jira Configuration
export JIRA_URL="${JIRA_URL}"
export JIRA_EMAIL="${JIRA_EMAIL}"
export JIRA_API_TOKEN="${JIRA_API_TOKEN}"
EOF
    echo "✓ Jira credentials added to .bashrc"
fi

echo ""
echo "Installing Jira helper functions..."

# Check if functions already exist
if grep -q "# Jira Helper Functions" ~/.bashrc; then
    # Remove old functions
    # macOS requires empty string for -i flag
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' '/# Jira Helper Functions/,/^}$/d' ~/.bashrc
    else
        sed -i '/# Jira Helper Functions/,/^}$/d' ~/.bashrc
    fi
    echo "✓ Removed old Jira helper functions"
fi

# Add Jira helper functions
cat >> ~/.bashrc << 'EOF'

# Jira Helper Functions
jira-my-tickets() {
  echo "=== My Open Tickets ==="
  echo ""
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/search/jql" \
    -H "Content-Type: application/json" \
    -d '{"jql": "assignee=currentUser() AND resolution=Unresolved ORDER BY updated DESC", "fields": ["key", "summary", "status", "priority"], "maxResults": 50}' \
    | jq -r '.issues[] | "\(.key) - \(.fields.summary)\n  Status: \(.fields.status.name) | Priority: \(.fields.priority.name)\n"'
  echo "---"
}

jira-get() {
  echo "=== Ticket: $1 ==="
  echo ""
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X GET "${JIRA_URL}/rest/api/3/issue/$1" \
    | jq -r '"Key: \(.key)
Summary: \(.fields.summary)
Type: \(.fields.issuetype.name)
Status: \(.fields.status.name)
Priority: \(.fields.priority.name)
Reporter: \(.fields.reporter.displayName)
Assignee: \(.fields.assignee.displayName // "Unassigned")
Created: \(.fields.created)
Updated: \(.fields.updated)"'
  echo ""
  echo "---"
}

jira-summary() {
  local ticket=$1
  echo "=== Ticket Summary: $ticket ==="
  echo ""

  # Get full ticket details including links
  local response=$(curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X GET "${JIRA_URL}/rest/api/3/issue/${ticket}?fields=summary,issuetype,status,priority,reporter,assignee,created,updated,parent,subtasks,issuelinks,labels,components")

  # Basic info
  echo "$response" | jq -r '"📋 Basic Info
Key: \(.key)
Summary: \(.fields.summary)
Type: \(.fields.issuetype.name)
Status: \(.fields.status.name)
Priority: \(.fields.priority.name)
Reporter: \(.fields.reporter.displayName)
Assignee: \(.fields.assignee.displayName // "Unassigned")
Created: \(.fields.created[:10])
Updated: \(.fields.updated[:10])"'

  # Labels
  local labels=$(echo "$response" | jq -r '.fields.labels[]?' 2>/dev/null)
  if [ -n "$labels" ]; then
    echo ""
    echo "🏷️  Labels:"
    echo "$labels" | sed 's/^/  - /'
  fi

  # Components
  local components=$(echo "$response" | jq -r '.fields.components[]?.name' 2>/dev/null)
  if [ -n "$components" ]; then
    echo ""
    echo "🔧 Components:"
    echo "$components" | sed 's/^/  - /'
  fi

  # Parent ticket
  local parent=$(echo "$response" | jq -r '.fields.parent.key?' 2>/dev/null)
  if [ -n "$parent" ] && [ "$parent" != "null" ]; then
    local parent_summary=$(echo "$response" | jq -r '.fields.parent.fields.summary')
    echo ""
    echo "⬆️  Parent:"
    echo "  ${parent} - ${parent_summary}"
  fi

  # Subtasks
  local subtasks=$(echo "$response" | jq -r '.fields.subtasks[]? | "  \(.key) - \(.fields.summary) [\(.fields.status.name)]"' 2>/dev/null)
  if [ -n "$subtasks" ]; then
    echo ""
    echo "⬇️  Subtasks:"
    echo "$subtasks"
  fi

  # Issue links (blocks, is blocked by, relates to, etc.)
  local inward_links=$(echo "$response" | jq -r '.fields.issuelinks[]? | select(.inwardIssue) | "  \(.type.inward): \(.inwardIssue.key) - \(.inwardIssue.fields.summary) [\(.inwardIssue.fields.status.name)]"' 2>/dev/null)
  local outward_links=$(echo "$response" | jq -r '.fields.issuelinks[]? | select(.outwardIssue) | "  \(.type.outward): \(.outwardIssue.key) - \(.outwardIssue.fields.summary) [\(.outwardIssue.fields.status.name)]"' 2>/dev/null)

  if [ -n "$inward_links" ] || [ -n "$outward_links" ]; then
    echo ""
    echo "🔗 Related Issues:"
    [ -n "$inward_links" ] && echo "$inward_links"
    [ -n "$outward_links" ] && echo "$outward_links"
  fi

  echo ""
  echo "---"
}

jira-comment() {
  local ticket=$1
  local comment=$2
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/issue/${ticket}/comment" \
    -H "Content-Type: application/json" \
    -d "{\"body\":{\"type\":\"doc\",\"version\":1,\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"${comment}\"}]}]}}"
}

jira-bugs-filed() {
  local start_date=$1
  local end_date=$2
  echo "=== Bugs Filed: $start_date to $end_date ==="
  echo ""
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/search/jql" \
    -H "Content-Type: application/json" \
    -d "{\"jql\": \"reporter=currentUser() AND issuetype=Bug AND created >= ${start_date} AND created <= ${end_date} ORDER BY created DESC\", \"fields\": [\"key\", \"summary\", \"status\", \"priority\", \"created\"], \"maxResults\": 200}" \
    | jq -r '"\nTotal: \(.total) bugs\n" , (.issues[] | "\(.key) - \(.fields.summary)\n  Priority: \(.fields.priority.name) | Status: \(.fields.status.name) | Created: \(.fields.created[:10])\n")'
  echo "---"
}

jira-created-quarterly() {
  local start_date=$1
  local end_date=$2
  echo "=== Tickets Created: $start_date to $end_date ==="
  echo ""
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/search/jql" \
    -H "Content-Type: application/json" \
    -d "{\"jql\": \"reporter=currentUser() AND created >= ${start_date} AND created <= ${end_date} ORDER BY created DESC\", \"fields\": [\"key\", \"summary\", \"issuetype\", \"status\", \"created\"], \"maxResults\": 200}" \
    | jq -r '"\nTotal: \(.total) tickets\n" , (.issues[] | "\(.key) - \(.fields.summary)\n  Type: \(.fields.issuetype.name) | Status: \(.fields.status.name) | Created: \(.fields.created[:10])\n")'
  echo "---"
}

jira-bugs-filed-90days() {
  echo "=== Bugs Filed (Last 90 Days) ==="
  echo ""
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/search/jql" \
    -H "Content-Type: application/json" \
    -d '{"jql": "reporter=currentUser() AND issuetype=Bug AND created >= -90d ORDER BY created DESC", "fields": ["key", "summary", "status", "priority", "created"], "maxResults": 200}' \
    | jq -r '"\nTotal: \(.total) bugs\n" , (.issues[] | "\(.key) - \(.fields.summary)\n  Priority: \(.fields.priority.name) | Status: \(.fields.status.name) | Created: \(.fields.created[:10])\n")'
  echo "---"
}

jira-created-90days() {
  echo "=== Tickets Created (Last 90 Days) ==="
  echo ""
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/search/jql" \
    -H "Content-Type: application/json" \
    -d '{"jql": "reporter=currentUser() AND created >= -90d ORDER BY created DESC", "fields": ["key", "summary", "issuetype", "status", "created"], "maxResults": 200}' \
    | jq -r '"\nTotal: \(.total) tickets\n" , (.issues[] | "\(.key) - \(.fields.summary)\n  Type: \(.fields.issuetype.name) | Status: \(.fields.status.name) | Created: \(.fields.created[:10])\n")'
  echo "---"
}

jira-worked-90days() {
  echo "=== Tickets Worked On (Last 90 Days) ==="
  echo ""
  curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X POST "${JIRA_URL}/rest/api/3/search/jql" \
    -H "Content-Type: application/json" \
    -d '{"jql": "(reporter=currentUser() OR assignee=currentUser() OR comment ~ currentUser()) AND updated >= -90d ORDER BY updated DESC", "fields": ["key", "summary", "issuetype", "status", "updated"], "maxResults": 200}' \
    | jq -r '"\nTotal: \(.total) tickets\n" , (.issues[] | "\(.key) - \(.fields.summary)\n  Type: \(.fields.issuetype.name) | Status: \(.fields.status.name) | Updated: \(.fields.updated[:10])\n")'
  echo "---"
}
EOF

echo "✓ Jira helper functions added to .bashrc"
echo ""
echo "=================================================="
echo "Setup Complete!"
echo "=================================================="
echo ""
echo "Run this command to activate the changes:"
echo "  source ~/.bashrc"
echo ""
echo "Test your setup with:"
echo "  jira-my-tickets"
echo ""
echo "Next steps:"
echo "  - Check out README.md for full documentation"
echo "  - Browse templates/ for ready-to-use templates"
echo "  - See commands/jira-common-commands.md for all available commands"
echo ""
