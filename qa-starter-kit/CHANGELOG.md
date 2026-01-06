# QA Toolbox Changelog

## [Beta] - 2025-12-19

### 🎉 Major New Feature: AI-Powered Ticket Summaries
- Added `jira-summary` command that uses Claude API to intelligently analyze tickets
- Provides concise summaries covering:
  - What the ticket is about (problem/goal)
  - Current status and what needs to be done
  - Key relationships (parents, subtasks, blockers, related tickets)
- Falls back gracefully if ANTHROPIC_API_KEY not set

### ✨ New: Standalone CLI Wrapper (Recommended)
- Added `jira-cli.sh` - Use the toolbox without modifying `.bashrc`!
- Simple command-line interface: `./jira-cli.sh my-tickets`
- Self-documenting help system
- No installation required - just clone and run

### 🔧 Improvements
- **Fixed line ending issues** - Added `.gitattributes` to ensure consistent LF line endings across platforms
- **Test scripts** - Added `test-jira-connection.sh` and `load-functions.sh` for easy testing
- **Example outputs** - Added example command outputs to README
- **Better documentation** - Updated README to promote no-install CLI wrapper method

### 📝 New Files
- `jira-cli.sh` - Standalone CLI wrapper (no .bashrc edits needed)
- `load-functions.sh` - Temporarily load functions without installation
- `test-jira-connection.sh` - Test your Jira API connection
- `USABILITY_TEST_RESULTS.md` - Comprehensive testing documentation
- `CHANGELOG.md` - This file
- `.gitattributes` - Enforce LF line endings

### 🐛 Bug Fixes
- Fixed CRLF line ending issues in bash scripts
- Normalized all shell scripts to LF for cross-platform compatibility
- Fixed JSON escaping issues in Claude API calls

### 📚 Documentation Updates
- Reorganized README to prioritize CLI wrapper method
- Added example outputs for all commands
- Added AI summary setup instructions
- Updated all command examples to use CLI wrapper syntax
- Added troubleshooting section

### 🔄 Modified Files
- `README.md` - Major updates, new quick start guide
- `setup.sh` - Added `jira-summary` function
- `check-personal-info.sh` - Line ending fixes

## Usage

### New Recommended Method (No Installation)
```bash
# Set credentials
export JIRA_URL='https://eagleeyenetworks.atlassian.net'
export JIRA_EMAIL='your@email.com'
export JIRA_API_TOKEN='your-token'

# Optional: Enable AI summaries
export ANTHROPIC_API_KEY='your-claude-api-key'

# Use the CLI
./jira-cli.sh my-tickets
./jira-cli.sh summary EEPD-12345
```

### Traditional Method (Still Available)
```bash
./setup.sh  # One-time setup
source ~/.bashrc
jira-my-tickets  # Works from anywhere
```

## Breaking Changes
None - all existing functionality preserved.

## Requirements
- `curl` - For API calls
- `jq` - For JSON parsing
- **Optional**: Anthropic API key for AI-powered summaries

## What's Next
See [qa-toolbox-roadmap.md](qa-toolbox-roadmap.md) for future plans.
