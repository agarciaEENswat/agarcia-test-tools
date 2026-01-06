# QA Toolbox

Quick-start templates, commands, and workflows to make QA paperwork faster and more consistent.

## The Problem

Paperwork is the least fun part of QA, so it's often inconsistent and poorly done.

## The Solution

Make boring paperwork:
- **Copy-paste ready** (minimal thinking required)
- **Quick reference** (not long docs to read)
- **Templates with examples** (modify, don't create from scratch)
- **Scripts/commands ready to run** (no setup needed)

---

## Quick Start (No Installation Required!)

### 1. Clone the Repository

```bash
git clone <repository-url>
cd qa-toolbox
```

### 2. Set Your Credentials

```bash
export JIRA_URL='https://eagleeyenetworks.atlassian.net'
export JIRA_EMAIL='your-email@een.com'
export JIRA_API_TOKEN='your-api-token'
```

See [setup/jira-setup-instructions.md](setup/jira-setup-instructions.md) for how to get your API token.

### 3. Run the CLI

```bash
./jira-cli.sh my-tickets
./jira-cli.sh summary EEPD-12345
```

That's it! No `.bashrc` modifications required.

**Pro tip**: Add credentials to a file you can source:
```bash
# Save credentials in ~/.jira-credentials
echo "export JIRA_URL='https://eagleeyenetworks.atlassian.net'" > ~/.jira-credentials
echo "export JIRA_EMAIL='your-email@een.com'" >> ~/.jira-credentials
echo "export JIRA_API_TOKEN='your-token'" >> ~/.jira-credentials

# Use it
source ~/.jira-credentials
./jira-cli.sh my-tickets
```

---

## Alternative: Install Functions Globally

If you want functions available everywhere without the `./jira-cli.sh` prefix:

```bash
./setup.sh  # Installs to ~/.bashrc
source ~/.bashrc
jira-my-tickets  # Works from any directory
```

See [setup/jira-setup-instructions.md](setup/jira-setup-instructions.md) for detailed installation instructions.

---

## What's Included

### Setup Documentation
| File | Description |
|------|-------------|
| [setup/jira-setup-instructions.md](setup/jira-setup-instructions.md) | Detailed Jira API setup guide |

### Templates
| File | Description |
|------|-------------|
| [templates/test-plan-template.md](templates/test-plan-template.md) | Standard test plan format |
| [templates/bug-report-template.md](templates/bug-report-template.md) | Bug report with severity guidelines |
| [templates/test-summary-report-template.md](templates/test-summary-report-template.md) | Test execution summary with Qmetry integration |

**Confluence Pages:**
- [QA Bug Report Template](https://eagleeyenetworks.atlassian.net/wiki/spaces/ENG/pages/4115562516/QA+Bug+Report+Template)
- [QA Test Summary Report Template](https://eagleeyenetworks.atlassian.net/wiki/spaces/ENG/pages/4115791882/QA+Test+Summary+Report+Template)

### Commands & Queries
| File | Description |
|------|-------------|
| [commands/jira-common-commands.md](commands/jira-common-commands.md) | Common Jira operations and review queries |

### Workflows
| File | Description |
|------|-------------|
| [workflows/quarterly-review-process.md](workflows/quarterly-review-process.md) | SMART Accomplishments & Objectives guide |

### Planning
| File | Description |
|------|-------------|
| [qa-toolbox-roadmap.md](qa-toolbox-roadmap.md) | Future plans and team pain points |

---

## Available Commands

Run commands using the CLI wrapper:

### Daily Commands
```bash
./jira-cli.sh my-tickets              # Show your open tickets
./jira-cli.sh get EEPD-12345          # Get ticket details
./jira-cli.sh summary EEPD-12345      # Get AI-powered summary with relationships
./jira-cli.sh triage EEPD-12345       # Get AI-powered troubleshooting guidance
./jira-cli.sh comment EEPD-12345 "text"  # Add comment to ticket
```

**Example Output:**
```
=== My Open Tickets ===

EEPD-105874 - QA_EEVA - Manual Test Plan Creation and Execution Task
  Status: To Do | Priority: Lowest

EEPD-102486 - QA - VMS Experience - Unable to login to account
  Status: To Do | Priority: Medium
---
```

### Review Period Commands (90 days)
```bash
./jira-cli.sh bugs-90days         # Bugs filed in last 90 days
./jira-cli.sh created-90days      # Tickets created in last 90 days
./jira-cli.sh worked-90days       # Tickets worked on in last 90 days
```

**Example Output:**
```
=== Bugs Filed (Last 90 Days) ===

Total: 3 bugs

EEPD-102486 - QA - VMS Experience - Unable to login to account
  Priority: Medium | Status: To Do | Created: 2025-11-03

EEPD-101855 - QA_GunDetection - Events not populating
  Priority: Medium | Status: Triage | Created: 2025-10-24
---
```

### Date Range Commands
```bash
./jira-cli.sh bugs-range 2025-09-15 2025-12-15    # Bugs filed in date range
./jira-cli.sh quarterly 2025-09-15 2025-12-15     # Tickets created in date range
```

### Get All Available Commands
```bash
./jira-cli.sh  # Shows help with all available commands
```

---

## Common Use Cases

### "I need to file a bug"
1. Open [templates/bug-report-template.md](templates/bug-report-template.md)
2. Copy the template
3. Fill in all sections
4. Use format: `QA_[Component] - Description`

### "I need to write a test plan"
1. Open [templates/test-plan-template.md](templates/test-plan-template.md)
2. Copy the entire template
3. Fill in each section

### "I need to write a test summary report"
1. Open [templates/test-summary-report-template.md](templates/test-summary-report-template.md)
2. Run `jira-bugs-filed-90days` to get your bugs
3. Fill in the template with test results

### "I need to do my quarterly review"
1. Run: `./jira-cli.sh bugs-90days > my-bugs.json`
2. Run: `./jira-cli.sh created-90days > my-tickets.json`
3. Run: `./jira-cli.sh worked-90days > my-work.json`
4. Follow [workflows/quarterly-review-process.md](workflows/quarterly-review-process.md)

### "I need to understand a complex ticket"
1. Run: `./jira-cli.sh summary EEPD-12345`
2. Get AI-powered analysis of what it's about, status, and relationships

### "I need help troubleshooting a technical issue"
1. Run: `./jira-cli.sh triage EEPD-12345`
2. Get AI-powered troubleshooting guidance with:
   - Issue category identification
   - Specific diagnostic commands to run
   - Step-by-step investigation checklist
   - Likely root causes
   - Relevant technical documentation sections
   - Escalation criteria

**Requirements:**
- `ANTHROPIC_API_KEY` environment variable must be set
- `EEN-Master-Technical-Reference.md` must be in one of these locations:
  - `~/agarcia-test-tools/EEN-Master-Technical-Reference.md`
  - `~/test-tools/EEN-Master-Technical-Reference.md`
  - Current working directory

### "I need to search Jira"
Check [commands/jira-common-commands.md](commands/jira-common-commands.md) for all available queries

---

## Examples

### Bug Title Format
```
QA_WebUI - Application crashes when opening History Browser
QA_Gun Detection - Event thumbnail shows wrong timestamp
QA_Mobile - Login button not responsive on iOS 17
```

### SMART Accomplishment Format
```
Filed 47 QA bugs (12 Critical, 18 High, 17 Medium) during Q4 2025
with 89% resolved before release, contributing to highest quality
release of the year
```

### SMART Objective Format
```
Reduce critical bug escape rate from 8% to below 5% by implementing
automated smoke test suite that runs pre-release by February 28, 2026
```

---

## Tips for Success

### For Bug Reports
- Always use `QA_` prefix
- Include exact steps to reproduce
- Attach screenshots
- Set severity correctly
- Check for duplicates first

### For Test Plans
- Fill in all sections
- Be specific about scope
- Define clear pass/fail criteria
- List all dependencies

### For Reviews
- Focus on "what you made" not "what you closed"
- Use strong action verbs
- Include numbers and metrics
- Show business impact
- Be honest and accurate

---

## Updating to Latest Version

To get the latest templates and commands:

```bash
cd qa-toolbox
git pull
./setup.sh  # Re-run setup if functions were updated
source ~/.bashrc
```

---

## Troubleshooting

### "Permission denied: ./jira-cli.sh"
```bash
chmod +x jira-cli.sh
```

### "Command not found: jira-my-tickets" (if you used setup.sh)
```bash
source ~/.bashrc
```

### "Expecting value: line 1 column 1"
Your Jira credentials may be incorrect. Check:
1. JIRA_URL is correct
2. JIRA_EMAIL is your Atlassian email
3. JIRA_API_TOKEN is valid (not expired)

Re-run setup:
```bash
./setup.sh
```

### Getting Help
- Check [setup/jira-setup-instructions.md](setup/jira-setup-instructions.md) for detailed troubleshooting
- See [commands/jira-common-commands.md](commands/jira-common-commands.md) for command examples
- Review existing templates for guidance

---

## Contributing

Found a bug or have a suggestion? Talk to the team or submit an update.

### Adding New Templates
1. Create your template in the appropriate directory
2. Add it to this README
3. Update [qa-toolbox-roadmap.md](qa-toolbox-roadmap.md)

### Adding New Commands
1. Add command to [commands/jira-common-commands.md](commands/jira-common-commands.md)
2. If it's a bash function, add to `setup.sh`
3. Update this README

---

## Repository Structure

```
qa-toolbox/
├── README.md                           # This file
├── setup.sh                            # Automated installation script
├── setup/
│   └── jira-setup-instructions.md     # Detailed Jira setup guide
├── templates/
│   ├── bug-report-template.md         # Bug report template
│   ├── test-plan-template.md          # Test plan template
│   └── test-summary-report-template.md # Test summary report template
├── commands/
│   └── jira-common-commands.md        # Jira API commands reference
├── workflows/
│   └── quarterly-review-process.md    # SMART review guide
└── qa-toolbox-roadmap.md              # Future plans
```

---

## Version

**v1.0** - Initial release

### What's Included
- Automated setup script
- Jira setup guide
- Bug report template (markdown + Confluence)
- Test plan template
- Test summary report template (with Qmetry integration)
- Common Jira commands with 90-day rolling queries
- Quarterly review process (SMART A's & O's)

### Coming Soon (v1.1+)
- Release Testing Checklist
- Test Case Writing Guidelines
- Confluence Access Patterns

See [qa-toolbox-roadmap.md](qa-toolbox-roadmap.md) for full roadmap.

---

## Philosophy

**Keep it simple. Keep it practical. Keep it copy-paste ready.**

The best template is one that gets used. The best process is one that saves time.

---

## License

Internal use for Eagle Eye Networks QA Team.
