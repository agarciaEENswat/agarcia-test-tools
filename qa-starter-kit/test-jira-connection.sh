#!/bin/bash

# Test Jira Connection Script
# This script tests your Jira API connection without modifying .bashrc

echo "=================================================="
echo "QA Toolbox - Jira Connection Test"
echo "=================================================="
echo ""

# Check if environment variables are set
if [ -z "$JIRA_URL" ] || [ -z "$JIRA_EMAIL" ] || [ -z "$JIRA_API_TOKEN" ]; then
    echo "❌ Jira credentials not found in environment"
    echo ""
    echo "You have two options:"
    echo ""
    echo "1. Source your credentials file first:"
    echo "   source ../bwhite/credentials.sh"
    echo "   ./test-jira-connection.sh"
    echo ""
    echo "2. Set environment variables manually:"
    echo "   export JIRA_URL='https://eagleeyenetworks.atlassian.net'"
    echo "   export JIRA_EMAIL='your-email@een.com'"
    echo "   export JIRA_API_TOKEN='your-token'"
    echo "   ./test-jira-connection.sh"
    echo ""
    exit 1
fi

echo "✓ Environment variables found:"
echo "  JIRA_URL: $JIRA_URL"
echo "  JIRA_EMAIL: $JIRA_EMAIL"
echo "  JIRA_API_TOKEN: ${JIRA_API_TOKEN:0:10}... (hidden)"
echo ""

echo "Testing API connection..."
echo ""

# Test the connection with a simple API call
response=$(curl -s -w "\n%{http_code}" -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X GET "${JIRA_URL}/rest/api/3/myself")

http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" = "200" ]; then
    echo "✅ SUCCESS - Connected to Jira!"
    echo ""
    echo "Your Jira account info:"
    echo "$body" | jq -r '"  Name: \(.displayName)\n  Email: \(.emailAddress)\n  Account ID: \(.accountId)"'
    echo ""
    echo "=================================================="
    echo "✅ All tests passed!"
    echo "=================================================="
    echo ""
    echo "You can now use the Jira helper functions."
    echo "Try: ./load-functions.sh"
    exit 0
else
    echo "❌ FAILED - Could not connect to Jira"
    echo ""
    echo "HTTP Status Code: $http_code"
    echo ""
    if [ "$http_code" = "401" ]; then
        echo "Error: Authentication failed"
        echo "  - Check that JIRA_EMAIL is correct"
        echo "  - Check that JIRA_API_TOKEN is valid and not expired"
        echo "  - See setup/jira-setup-instructions.md for help"
    elif [ "$http_code" = "000" ]; then
        echo "Error: Could not reach server"
        echo "  - Check that JIRA_URL is correct"
        echo "  - Check your network connection"
    else
        echo "Response:"
        echo "$body" | jq '.' 2>/dev/null || echo "$body"
    fi
    echo ""
    exit 1
fi
