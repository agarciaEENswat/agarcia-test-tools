#!/bin/bash

# Jira CLI - Standalone wrapper script
# No .bashrc modifications required!

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source the functions
source "$SCRIPT_DIR/load-functions.sh" > /dev/null 2>&1

# If no arguments provided, show help
if [ $# -eq 0 ]; then
    echo "Jira CLI - QA Toolbox"
    echo ""
    echo "Usage: ./jira-cli.sh <command> [arguments]"
    echo ""
    echo "Available commands:"
    echo "  my-tickets              - Show your open tickets"
    echo "  get TICKET-ID           - Get ticket details"
    echo "  summary TICKET-ID       - Get AI-powered summary with relationships"
    echo "  triage TICKET-ID        - Get AI-powered troubleshooting guidance"
    echo "  create TICKET-ID        - Generate ticket template for copy/paste"
    echo "  comment TICKET-ID 'msg' - Add comment to ticket"
    echo "  bugs-90days             - Bugs filed in last 90 days"
    echo "  created-90days          - All tickets created in last 90 days"
    echo "  worked-90days           - Tickets worked on in last 90 days"
    echo "  bugs-range START END    - Bugs filed in date range"
    echo ""
    echo "Examples:"
    echo "  ./jira-cli.sh my-tickets"
    echo "  ./jira-cli.sh summary EEPD-70449"
    echo "  ./jira-cli.sh triage EENS-133121"
    echo "  ./jira-cli.sh create EEPD-106946"
    echo "  ./jira-cli.sh comment EEPD-12345 'Testing complete'"
    echo ""
    exit 0
fi

# Parse command and execute
COMMAND=$1
shift

case "$COMMAND" in
    my-tickets)
        jira-my-tickets "$@"
        ;;
    get)
        jira-get "$@"
        ;;
    summary)
        jira-summary "$@"
        ;;
    triage)
        jira-triage "$@"
        ;;
    create)
        jira-create "$@"
        ;;
    comment)
        jira-comment "$@"
        ;;
    bugs-90days)
        jira-bugs-filed-90days "$@"
        ;;
    created-90days)
        jira-created-90days "$@"
        ;;
    worked-90days)
        jira-worked-90days "$@"
        ;;
    bugs-range)
        jira-bugs-filed "$@"
        ;;
    quarterly)
        jira-created-quarterly "$@"
        ;;
    *)
        echo "Unknown command: $COMMAND"
        echo "Run './jira-cli.sh' with no arguments to see available commands"
        exit 1
        ;;
esac
