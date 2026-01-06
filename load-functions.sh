#!/bin/bash

# Load Jira Functions Temporarily
# This script loads the Jira helper functions into your current shell
# without modifying .bashrc (useful for testing)

# Source this script with: source ./load-functions.sh

# Check if being sourced
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    echo "❌ Error: This script must be sourced, not executed"
    echo ""
    echo "Usage:"
    echo "  source ./load-functions.sh"
    echo ""
    echo "Or shorter:"
    echo "  . ./load-functions.sh"
    echo ""
    exit 1
fi

echo "Loading Jira helper functions..."

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Try to source credentials file if it exists
if [ -f "$SCRIPT_DIR/credentials.sh" ]; then
    source "$SCRIPT_DIR/credentials.sh"
    echo "✓ Loaded credentials from credentials.sh"
fi

# Check if credentials are set
if [ -z "$JIRA_URL" ] || [ -z "$JIRA_EMAIL" ] || [ -z "$JIRA_API_TOKEN" ]; then
    echo "⚠️  Warning: Jira credentials not found"
    echo "   Edit credentials.sh and add your Jira details"
    echo "   Get API token from: https://id.atlassian.com/manage-profile/security/api-tokens"
    echo ""
fi

# Define all Jira helper functions
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

  # Check if ANTHROPIC_API_KEY is set
  if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "❌ Error: ANTHROPIC_API_KEY environment variable not set"
    echo "   Set it with: export ANTHROPIC_API_KEY='your-api-key'"
    echo ""
    echo "   Falling back to basic summary..."
    echo ""
  fi

  # Get full ticket details including links
  local response=$(curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X GET "${JIRA_URL}/rest/api/3/issue/${ticket}?fields=summary,description,issuetype,status,priority,reporter,assignee,created,updated,parent,subtasks,issuelinks,labels,components,comment")

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

  # Description
  local description=$(echo "$response" | jq -r '.fields.description.content[]?.content[]?.text' 2>/dev/null | head -20)
  if [ -n "$description" ]; then
    echo ""
    echo "📝 Description:"
    echo "$description" | sed 's/^/  /'
  fi

  # If Claude API key is available, generate AI summary
  if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo ""
    echo "🤖 AI Summary:"
    echo "  Analyzing ticket with Claude..."
    echo ""

    # Prepare ticket data for Claude - simplified to avoid JSON escaping issues
    local ticket_text=$(echo "$response" | jq -r '
      "Key: " + .key + "\n" +
      "Summary: " + .fields.summary + "\n" +
      "Type: " + .fields.issuetype.name + "\n" +
      "Status: " + .fields.status.name + "\n" +
      "Priority: " + .fields.priority.name + "\n" +
      "Reporter: " + .fields.reporter.displayName + "\n" +
      "Assignee: " + (.fields.assignee.displayName // "Unassigned") + "\n" +
      "Labels: " + ([.fields.labels[]?] | join(", ")) + "\n" +
      "Components: " + ([.fields.components[]?.name] | join(", ")) + "\n" +
      "\nDescription:\n" + ([.fields.description.content[]?.content[]?.text] | join("\n")) + "\n" +
      (if .fields.parent then "\nParent: " + .fields.parent.key + " - " + .fields.parent.fields.summary + "\n" else "" end) +
      (if (.fields.subtasks | length) > 0 then "\nSubtasks:\n" + ([.fields.subtasks[]? | "- " + .key + " (" + .fields.status.name + "): " + .fields.summary] | join("\n")) + "\n" else "" end) +
      (if (.fields.issuelinks | length) > 0 then "\nRelated Issues:\n" + ([.fields.issuelinks[]? | if .inwardIssue then "- " + .type.inward + ": " + .inwardIssue.key + " (" + .inwardIssue.fields.status.name + ")" else "- " + .type.outward + ": " + .outwardIssue.key + " (" + .outwardIssue.fields.status.name + ")" end] | join("\n")) + "\n" else "" end) +
      (if (.fields.comment.comments | length) > 0 then "\nRecent Comments:\n" + ([.fields.comment.comments[-3:] | reverse[] | "- " + .author.displayName + " (" + .created[:10] + "): " + ([.body.content[]?.content[]?.text] | join(" "))] | join("\n")) + "\n" else "" end)
    ')

    # Read CLAUDE.md template if available
    local claude_template=$(cat ~/.claude/CLAUDE.md 2>/dev/null || echo "")

    # Create a properly escaped JSON request using jq
    local temp_file=$(mktemp)
    local prompt="${claude_template}

Analyze this Jira ticket and provide a comprehensive technical summary using the format above.

Ticket Info:
${ticket_text}"

    # Use jq to properly escape the content
    jq -n \
      --arg model "claude-3-5-haiku-20241022" \
      --argjson max_tokens 2048 \
      --arg content "$prompt" \
      '{
        model: $model,
        max_tokens: $max_tokens,
        messages: [{
          role: "user",
          content: $content
        }]
      }' > "$temp_file"

    # Call Claude API
    local claude_response=$(curl -s https://api.anthropic.com/v1/messages \
      -H "Content-Type: application/json" \
      -H "x-api-key: $ANTHROPIC_API_KEY" \
      -H "anthropic-version: 2023-06-01" \
      -d @"$temp_file")

    # Clean up temp file
    rm -f "$temp_file"

    # Extract and display Claude's summary
    local ai_summary=$(echo "$claude_response" | jq -r '.content[0].text' 2>/dev/null)

    if [ -z "$ai_summary" ] || [ "$ai_summary" = "null" ]; then
      # Check for API error
      local error_msg=$(echo "$claude_response" | jq -r '.error.message' 2>/dev/null)
      if [ -n "$error_msg" ] && [ "$error_msg" != "null" ]; then
        echo "  ❌ API Error: $error_msg" | sed 's/^/  /'
      else
        echo "  ❌ Could not generate AI summary (check API key or rate limits)"
      fi
    else
      echo "$ai_summary" | sed 's/^/  /'
    fi
    echo ""
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

  # Recent comments (last 3)
  local has_comments=$(echo "$response" | jq -r '.fields.comment.comments | length' 2>/dev/null)
  if [ "$has_comments" -gt 0 ]; then
    echo ""
    echo "💬 Recent Comments:"
    echo "$response" | jq -r '.fields.comment.comments[-3:] | reverse[] | "  \(.author.displayName) (\(.created[:10])):\n" + ([.body.content[]?.content[]?.text] | join(" ") | "    " + .[0:200])' 2>/dev/null
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

jira-create() {
  local ticket=$1

  if [ -z "$ticket" ]; then
    echo "Usage: jira-create TICKET-ID"
    echo ""
    echo "This generates a copy-pasteable ticket template based on an existing ticket."
    echo ""
    echo "Example:"
    echo "  ./jira-cli.sh create EEPD-106946"
    return 1
  fi

  echo "=== Generating Ticket Template from $ticket ==="
  echo ""

  # Get the source ticket details (including related tickets and comments for AI context)
  local response=$(curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -X GET "${JIRA_URL}/rest/api/3/issue/${ticket}?fields=summary,description,issuetype,priority,labels,components,issuelinks,comment")

  # Extract fields
  local summary=$(echo "$response" | jq -r '.fields.summary')
  local description=$(echo "$response" | jq -r '[.fields.description.content[]?.content[]?.text] | join("\n")')
  local issuetype=$(echo "$response" | jq -r '.fields.issuetype.name')
  local priority=$(echo "$response" | jq -r '.fields.priority.name')
  local labels=$(echo "$response" | jq -r '[.fields.labels[]?] | join(", ")')
  local components=$(echo "$response" | jq -r '[.fields.components[]?.name] | join(", ")')

  # Parse description to extract specific fields
  local bridge_esn=$(echo "$description" | grep -i "ESN:" | grep -E "100[0-9a-f]{5}" | head -1 | grep -oE "100[0-9a-f]{5}")
  local bridge_ssn=$(echo "$description" | grep -i "SSN:" | head -1 | sed 's/.*SSN://' | xargs)
  local bridge_ip=$(echo "$description" | grep -i "IP Address:" | head -1 | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | head -1)
  local firmware=$(echo "$description" | grep -i "Firmware:" | head -1 | sed 's/.*Firmware://' | cut -d',' -f1 | xargs)
  local camera_esns=$(echo "$description" | grep -oE "100[0-9a-f]{5}" | sort -u | tr '\n' ', ' | sed 's/,$//')
  local support_pin=$(echo "$description" | grep -i "pin:" | grep -oE "[0-9]{6}" | head -1)
  local support_email=$(echo "$description" | grep -oE "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" | head -1)
  local account_info=$(echo "$description" | grep -i "Acct:" | head -1 | sed 's/.*Acct://' | xargs)
  local expected=$(echo "$description" | grep -A5 "Expected" | tail -n +2)
  local manufacturer=$(echo "$description" | grep -i "Manufacturer:" | head -1 | sed 's/.*Manufacturer://' | xargs)
  local model=$(echo "$description" | grep -i "Model:" | head -1 | sed 's/.*Model://' | xargs)

  # Generate AI analysis if API key is available
  local ai_analysis=""
  if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "Generating AI analysis..."

    # Prepare context for AI (include ALL comments for deep analysis)
    local ticket_context=$(echo "$response" | jq -r '
      "Ticket: " + .key + "\n" +
      "Summary: " + .fields.summary + "\n" +
      "Status: " + .fields.status.name + "\n" +
      "Priority: " + .fields.priority.name + "\n\n" +
      "Description:\n" + ([.fields.description.content[]?.content[]?.text] | join("\n")) + "\n\n" +
      (if (.fields.issuelinks | length) > 0 then "Related Issues:\n" + ([.fields.issuelinks[]? | if .inwardIssue then "- " + .type.inward + ": " + .inwardIssue.key + " - " + .inwardIssue.fields.summary + " [" + .inwardIssue.fields.status.name + "]" else "- " + .type.outward + ": " + .outwardIssue.key + " - " + .outwardIssue.fields.summary + " [" + .outwardIssue.fields.status.name + "]" end] | join("\n")) + "\n\n" else "" end) +
      (if (.fields.comment.comments | length) > 0 then "ALL Comments (chronological):\n" + ([.fields.comment.comments[] | "- " + .author.displayName + " (" + .created[:10] + "):\n  " + ([.body.content[]?.content[]?.text] | join(" ")) + "\n"] | join("\n")) else "" end)
    ')

    local temp_file=$(mktemp)
    local prompt="You are a senior technical analyst helping create a SWAT ticket. Analyze this ticket deeply and provide comprehensive guidance.

CONTEXT: An engineer wants to create a NEW ticket based on investigation in this existing ticket. Provide deep technical analysis.

ANALYZE THE FOLLOWING:

1. COMMENT ANALYSIS - Read ALL comments carefully:
   - What did engineers discover during investigation?
   - Are there mentions of separate issues or edge cases?
   - Did anyone recommend creating a separate ticket? Why?
   - What patterns or root causes were identified?

2. SEPARATE ISSUE IDENTIFICATION:
   - Is there a DISTINCT issue that deserves its own ticket?
   - What makes it different from the original ticket's focus?
   - Provide a clear, specific summary for the NEW ticket

3. TECHNICAL DEEP DIVE:
   - What is the root cause or system gap?
   - Walk through the timeline of events if applicable
   - Identify the technical mechanism that failed
   - Assess scope: one instance, account-wide, or system-wide?

4. INVESTIGATION QUESTIONS:
   - Generate 5-7 questions for Product/Engineering to answer
   - Focus on: current automation, intended behavior, edge cases, metrics

5. RECOMMENDED APPROACH:
   - IMMEDIATE: What needs to be done right now?
   - SHORT-TERM: How to fix this specific instance?
   - LONG-TERM: How to prevent this system-wide?

6. KEY DETAILS TO INCLUDE:
   - Extract all ESNs, account names, timestamps, event logs
   - Identify relationships (ESN reuse, account transfers, etc.)
   - Note any data/storage impacts

OUTPUT FORMAT - Structure your response as:

**SEPARATE ISSUE DETECTED:** [Yes/No - if yes, what is it?]

**NEW TICKET SUMMARY:** [Clear one-line summary]

**ROOT CAUSE:** [What system gap or failure occurred]

**TIMELINE:** [Chronological events if applicable]

**INVESTIGATION QUESTIONS:**
[Numbered list of questions for Engineering]

**RECOMMENDED APPROACH:**
IMMEDIATE: [Action items]
SHORT-TERM: [Fix steps]
LONG-TERM: [Prevention strategy]

**SCOPE ASSESSMENT:** [Impact range and risk]

Be thorough, technical, and actionable. This will be used to create a production SWAT ticket.

Ticket Info:
${ticket_context}"

    jq -n \
      --arg model "claude-3-5-haiku-20241022" \
      --argjson max_tokens 4096 \
      --arg content "$prompt" \
      '{
        model: $model,
        max_tokens: $max_tokens,
        messages: [{
          role: "user",
          content: $content
        }]
      }' > "$temp_file"

    local claude_response=$(curl -s https://api.anthropic.com/v1/messages \
      -H "Content-Type: application/json" \
      -H "x-api-key: $ANTHROPIC_API_KEY" \
      -H "anthropic-version: 2023-06-01" \
      -d @"$temp_file")

    # Debug: Check for API errors
    local api_error=$(echo "$claude_response" | jq -r '.error.message' 2>/dev/null)
    if [ -n "$api_error" ] && [ "$api_error" != "null" ]; then
      echo "⚠️  API Error: $api_error" >&2
      echo "   Using fallback analysis..." >&2
    fi

    rm -f "$temp_file"

    ai_analysis=$(echo "$claude_response" | jq -r '.content[0].text' 2>/dev/null)

    # Debug output
    if [ -z "$ai_analysis" ] || [ "$ai_analysis" = "null" ]; then
      echo "⚠️  No AI analysis generated (check API key/credits)" >&2
    fi

    # Check if AI detected a separate issue
    if echo "$ai_analysis" | grep -q "SEPARATE ISSUE DETECTED: Yes"; then
      echo ""
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "🔍 SEPARATE ISSUE DETECTED!"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "The AI analysis identified a distinct issue that should be a separate ticket."
      echo "Generating dedicated template for the new issue..."
      echo ""
    fi
  fi

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📋 SWAT TICKET TEMPLATE - Based on $ticket"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Project: EEPD"
  echo "Issue Type: $issuetype"
  echo "Priority: $priority [EDIT if needed - Highest only for Critical/All-Hands situations]"
  if [ -n "$labels" ] && [ "$labels" != "null" ]; then
    echo "Labels: $labels"
  fi
  if [ -n "$components" ] && [ "$components" != "null" ]; then
    echo "Components: $components"
  fi
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Summary:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  # If separate issue detected, use AI-generated summary
  if [ -n "$ai_analysis" ] && echo "$ai_analysis" | grep -q "SEPARATE ISSUE DETECTED: Yes"; then
    local new_summary=$(echo "$ai_analysis" | grep "NEW TICKET SUMMARY:" | sed 's/.*NEW TICKET SUMMARY: //')
    if [ -n "$new_summary" ]; then
      echo "$new_summary"
    else
      echo "[EDIT - Make descriptive and specific]"
      echo "$summary"
    fi
  else
    echo "[EDIT - Make descriptive and specific]"
    echo "$summary"
  fi
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Description:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Master account (cluster included):"
  if [ -n "$account_info" ]; then
    echo "$account_info"
  else
    echo "[EDIT - Account name and cluster, e.g., AccountName (cloud-prod-1)]"
  fi
  echo ""
  echo "Sub-account (cluster included):"
  echo "[EDIT - Sub-account name if applicable]"
  echo ""
  echo "Support PIN and email:"
  if [ -n "$support_pin" ] && [ -n "$support_email" ]; then
    echo "PIN: $support_pin"
    echo "Email: $support_email"
  elif [ -n "$support_email" ]; then
    echo "Email: $support_email"
    echo "PIN: [REQUIRED]"
  else
    echo "[REQUIRED - Support PIN and email for account access]"
  fi
  echo ""
  echo "Zoho Support Ticket #:"
  echo "[EDIT - Original support ticket number if escalated from Zoho]"
  echo ""
  echo "Bridge information:"
  if [ -n "$bridge_ssn" ]; then
    echo "  SSN: $bridge_ssn"
  fi
  if [ -n "$bridge_esn" ]; then
    echo "  Bridge ESN: $bridge_esn"
  else
    echo "  Bridge ESN: [EDIT - e.g., 1002XXXX]"
  fi
  if [ -n "$bridge_ip" ]; then
    echo "  IP Address: $bridge_ip"
  fi
  if [ -n "$firmware" ]; then
    echo "  Firmware Version: $firmware"
  else
    echo "  Firmware Version: [EDIT - Exact version from EEN Admin]"
  fi
  echo "  Location: [EDIT - Upstream(WAN) or Downstream(CamLAN)]"
  echo ""
  echo "Camera(s):"
  if [ -n "$camera_esns" ]; then
    echo "  Camera ESNs: $camera_esns"
    if [ -n "$manufacturer" ]; then
      echo "  Manufacturer: $manufacturer"
    fi
    if [ -n "$model" ]; then
      echo "  Model: $model"
    fi
  else
    echo "  Camera ESN: [EDIT - e.g., 100aXXXX]"
  fi
  echo "  Retention: [IMPORTANT - Note retention period and if close to expiration]"
  echo ""
  echo "3rd Party Equipment (if applicable):"
  echo "  [EDIT - List any encoders, SDS, Brivo, secondary audio, etc.]"
  echo ""
  echo "━━━ Problem Description (Customer Perspective) ━━━"
  # If separate issue, use ROOT CAUSE and TIMELINE from AI
  if [ -n "$ai_analysis" ] && echo "$ai_analysis" | grep -q "SEPARATE ISSUE DETECTED: Yes"; then
    local root_cause=$(echo "$ai_analysis" | sed -n '/\*\*ROOT CAUSE:\*\*/,/\*\*TIMELINE:\*\*/p' | sed '1d;$d')
    local timeline=$(echo "$ai_analysis" | sed -n '/\*\*TIMELINE:\*\*/,/\*\*INVESTIGATION QUESTIONS:\*\*/p' | sed '1d;$d')

    if [ -n "$root_cause" ]; then
      echo "ROOT CAUSE:"
      echo "$root_cause"
      echo ""
    fi

    if [ -n "$timeline" ]; then
      echo "TIMELINE OF EVENTS:"
      echo "$timeline"
      echo ""
    fi

    echo "Related to original ticket: $ticket - $summary"
  else
    echo "$description"
  fi
  echo ""
  if [ -n "$ai_analysis" ] && [ "$ai_analysis" != "null" ]; then
    echo "━━━ AI Technical Analysis ━━━"
    echo "$ai_analysis"
    echo ""
  fi
  echo "━━━ Support's Determination (Optional) ━━━"
  # For separate issues, pull from SCOPE ASSESSMENT
  if [ -n "$ai_analysis" ] && echo "$ai_analysis" | grep -q "SEPARATE ISSUE DETECTED: Yes"; then
    local scope=$(echo "$ai_analysis" | sed -n '/\*\*SCOPE ASSESSMENT:\*\*/,/\*\*ADDITIONAL/p' | sed '1d;$d')
    if [ -n "$scope" ]; then
      echo "$scope"
    else
      echo "[EDIT - Your technical assessment of the root cause]"
    fi
  else
    local troubleshooting=$(echo "$description" | grep -A10 -i "troubleshooting" | tail -n +2 | head -15)
    if [ -n "$troubleshooting" ]; then
      echo "$troubleshooting"
    else
      echo "[EDIT - Your technical assessment of the root cause]"
    fi
  fi
  echo ""
  echo "━━━ Reproduction Steps / Troubleshooting Done ━━━"
  local repro_steps=$(echo "$description" | grep -A10 -i "reproduction\|reproduce\|steps" | tail -n +2 | head -15)
  if [ -n "$repro_steps" ]; then
    echo "$repro_steps"
  else
    echo "[REQUIRED - Detailed steps to reproduce the issue]"
    echo "1. [EDIT]"
    echo "2. [EDIT]"
    echo "3. [EDIT]"
  fi
  echo ""
  echo "━━━ Expected Result ━━━"
  if [ -n "$expected" ]; then
    echo "$expected"
  else
    local expected_alt=$(echo "$description" | grep -A3 -i "expected result\|expected:" | tail -n +2)
    if [ -n "$expected_alt" ]; then
      echo "$expected_alt"
    else
      echo "[EDIT - What should happen normally]"
    fi
  fi
  echo ""
  echo "━━━ Actual Result ━━━"
  local actual=$(echo "$description" | grep -A3 -i "actual result\|actual:" | tail -n +2)
  if [ -n "$actual" ]; then
    echo "$actual"
  else
    echo "[EDIT - What actually happens - describe the problem behavior]"
  fi
  echo ""
  echo "━━━ Range of Impact ━━━"
  echo "[EDIT - Check all that apply:]"
  echo "☐ One Bridge (this bridge only)"
  echo "☐ Multiple Bridges on Site (how many: ___)"
  echo "☐ Account-wide Issue"
  echo "☐ Pod/Cluster-wide (provide multiple verified examples)"
  echo ""
  echo "━━━ Timestamps (UTC) ━━━"
  echo "[EDIT - Provide specific UTC timestamps of when issue occurred]"
  echo "Example: 2025-01-05 14:23:15 UTC"
  echo ""
  echo "━━━ User Experience Details ━━━"
  echo "Platform: [EDIT - Web App / Mobile]"
  echo "If Mobile:"
  echo "  - App Version: [EDIT]"
  echo "  - Phone OS Version: [EDIT]"
  echo "  - User Credentials: [EDIT - if needed to reproduce]"
  echo ""
  echo "━━━ Attachments ━━━"
  echo "[EDIT - List attachments. For videos, include timestamps of actions]"
  echo "- Screenshot: [Include URL in screenshot - use Alt+Print Screen for active window]"
  echo "- Bridge Diag: [If applicable]"
  echo "- Logs: [If applicable]"
  echo ""
  echo "━━━ Related Tickets ━━━"
  echo "Original Ticket: $ticket"
  echo "Related Jiras: [EDIT - Link related tickets if applicable]"
  echo ""
  if [ -n "$ai_analysis" ] && [ "$ai_analysis" != "null" ]; then
    # Extract investigation questions and recommendations if present
    if echo "$ai_analysis" | grep -q "INVESTIGATION QUESTIONS"; then
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "🔍 INVESTIGATION QUESTIONS FOR PRODUCT/ENGINEERING:"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "$ai_analysis" | sed -n '/INVESTIGATION QUESTIONS/,/RECOMMENDED APPROACH/p' | sed '1d;$d'
      echo ""
    fi
    if echo "$ai_analysis" | grep -q "RECOMMENDED APPROACH"; then
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "💡 RECOMMENDED TECHNICAL APPROACH:"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "$ai_analysis" | sed -n '/RECOMMENDED APPROACH/,/SCOPE ASSESSMENT/p' | sed '1d;$d'
      echo ""
    fi
  fi
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✅ CHECKLIST - Before submitting, verify:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "☐ Support PIN provided"
  echo "☐ Bridge ESN and exact firmware version included"
  echo "☐ Camera ESNs and retention noted"
  echo "☐ Clear reproduction steps provided"
  echo "☐ Timestamps in UTC format"
  echo "☐ Screenshots include URLs"
  echo "☐ Range of impact specified"
  echo "☐ Customer perspective problem description included"
  echo "☐ Expected vs actual results documented"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "💡 Reference: SWAT Ticket Guidelines"
  echo "   https://eagleeyenetworks.atlassian.net/wiki/spaces/ENG/pages/2691268878/"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
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

echo "✓ Jira helper functions loaded!"
echo ""
echo "Available commands:"
echo "  jira-my-tickets              - Show your open tickets"
echo "  jira-get TICKET-ID           - Get ticket details"
echo "  jira-summary TICKET-ID       - Get detailed summary with parent/child/related tickets"
echo "  jira-comment TICKET-ID 'msg' - Add comment"
echo "  jira-bugs-filed-90days       - Bugs filed in last 90 days"
echo "  jira-created-90days          - All tickets created in last 90 days"
echo "  jira-worked-90days           - Tickets worked on in last 90 days"
echo ""
echo "Try: jira-my-tickets"
echo ""
