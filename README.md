# agarcia-test-tools

Internal tools for Eagle Eye Networks support and engineering operations — dashboards, Claude skills, and QA utilities.

---

## Prerequisites

All tools in this repo authenticate against JIRA using environment variables. Add these to your `~/.zshrc` or `~/.bashrc`:

```bash
export JIRA_URL='https://eagleeyenetworks.atlassian.net'
export JIRA_EMAIL='your-email@een.com'
export JIRA_API_TOKEN='your-api-token'
```

To generate a JIRA API token: go to [id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens) → **Create API token**.

After adding to your shell config, run `source ~/.zshrc` to load them.

---

## Tools

### Customer Impact Health Dashboard

**File:** `scripts/ci-dashboard.py`

A local web dashboard that pulls live JIRA data and displays customer-impact ticket health in one view — including the team ownership breakdown that JIRA's native gadgets can't do.

**What it shows:**
| Section | Description |
|---------|-------------|
| Stat tiles | Total CI tickets, Highest/High/Medium counts, Due ≤3 days — all clickable to JIRA |
| By Priority | Doughnut chart — click a segment to open that priority filter in JIRA |
| By Engineering Team | Doughnut chart — click a segment to see that team's tickets inline |
| Age Distribution | Horizontal bar chart bucketed by ticket age (< 1 week → 6+ months) with High/Medium breakdown |
| Out of Spec | Tickets violating SLA: Highest >7d, High >14d, any >28d |
| Due Within 3 Days | Tickets with an approaching due date |
| Repeatedly Punted | Tickets that have been added to 3+ sprints without closing |
| Never in a Sprint | Tickets sitting in backlog with no engineering commitment |

All cards are **resizable** — drag the bottom-right corner. Sizes are saved to `localStorage` and restored on every load.

**Setup:**

```bash
# Install dependencies (uses the venv in ~/Scripts if available)
pip install flask

# Run
python scripts/ci-dashboard.py
```

Then open **http://localhost:8081** in your browser.

To run on a different port:
```bash
CI_DASH_PORT=9000 python scripts/ci-dashboard.py
```

---

### Morning Briefing (Claude Code Skill)

**File:** `claude-skills/morning-briefing/SKILL.md`

A Claude Code skill that runs a full daily JIRA briefing and sends it to Zulip as a DM.

**What it covers:**

| Section | Description |
|---------|-------------|
| New tickets since yesterday | New VMSSUP support tickets + new EEPD customer-impact tickets |
| High priority open | VMSSUP high/highest tickets, flagged if no movement in ≥3 days |
| Medium priority open | VMSSUP medium tickets, flagged if stalled ≥7 days |
| Total open customer impact | Age distribution chart with priority breakdown and delta vs. yesterday |
| Out of spec work items | CI tickets violating SLA thresholds by priority |
| Sprint carry-over | Repeatedly punted / carried over / never in sprint breakdown |
| Open tickets by engineering team | Per-team CI ticket counts with High/Medium breakdown and deltas |
| Needs team response | Tickets waiting on a team reply, urgency-scored via jira-stalker |

Also generates a full markdown report saved to `~/Documents/Morning Briefing/` and uploads it as an attachment to the Zulip DM.

**Additional env vars required:**

```bash
export ZULIP_EMAIL='your-email@een.com'
export ZULIP_API_KEY='your-zulip-api-key'
export ZULIP_SITE='https://chat.eencloud.com'
```

**How to run:**

In Claude Code, type:
```
/morning-briefing
```

To install the skill, copy `claude-skills/morning-briefing/SKILL.md` to:
```
~/.claude/skills/morning-briefing/SKILL.md
```

---

## Repository Structure

```
agarcia-test-tools/
├── README.md                                   # This file
├── scripts/
│   └── ci-dashboard.py                         # Customer Impact Health dashboard
├── claude-skills/
│   └── morning-briefing/
│       └── SKILL.md                            # Claude Code morning briefing skill
├── qa-starter-kit/                             # QA templates, commands, and workflows
│   └── README.md                               # QA toolbox docs
└── Notes/                                      # Reference docs and architecture notes
```

---

## License

Internal use for Eagle Eye Networks.
