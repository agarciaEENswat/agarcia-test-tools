# Jira API Access Setup

## Quick Setup for New Terminals

Run this command to add Jira credentials to your bash profile:

```bash
cat >> ~/.bashrc << 'EOF'

# Jira Configuration
export JIRA_URL="https://eagleeyenetworks.atlassian.net"
export JIRA_EMAIL="your-email@company.com"
export JIRA_API_TOKEN="your-jira-api-token-here"
EOF

source ~/.bashrc
```

## Manual Setup (Step by Step)

### 1. Edit Your Shell Configuration

**For Bash:**
```bash
nano ~/.bashrc
```

**For Zsh:**
```bash
nano ~/.zshrc
```

### 2. Add These Lines at the Bottom

```bash
# Jira Configuration
export JIRA_URL="https://eagleeyenetworks.atlassian.net"
export JIRA_EMAIL="your-email@company.com"
export JIRA_API_TOKEN="your-jira-api-token-here"
```

Save and exit (Ctrl+O, Enter, Ctrl+X in nano)

### 3. Reload Configuration

```bash
source ~/.bashrc  # or source ~/.zshrc
```

## Verify Setup

Check that variables are set:
```bash
echo $JIRA_URL
echo $JIRA_EMAIL
```

Test API connection:
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X GET "${JIRA_URL}/rest/api/3/myself" | head -20
```

## Common Jira API Commands

### Get Your Assigned Tickets
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{"jql": "assignee=currentUser() AND resolution=Unresolved ORDER BY updated DESC", "maxResults": 50}'
```

### Get a Specific Ticket
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X GET "${JIRA_URL}/rest/api/3/issue/EEPD-12345"
```

### Add a Comment to a Ticket
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
              "text": "Your comment here"
            }
          ]
        }
      ]
    }
  }'
```

## Getting Your Credentials

To get your Jira API token:
1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Click "Create API token"
3. Give it a name (e.g., "QA Toolbox")
4. Copy the token and use it in your setup

**Example values** (replace with your actual credentials):
- **Jira Instance**: https://your-company.atlassian.net
- **Email**: your-email@company.com
- **API Token**: your-api-token-from-atlassian

## Troubleshooting

**If commands don't work in new terminal:**
- Make sure you've run `source ~/.bashrc` or opened a new terminal session
- Verify variables are set with `echo $JIRA_URL`

**If using zsh instead of bash:**
- Edit `~/.zshrc` instead of `~/.bashrc`
- Run `source ~/.zshrc` to reload

## Security Note

Keep this file secure as it contains your API token. Do not commit it to version control.
