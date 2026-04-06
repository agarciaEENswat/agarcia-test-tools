# agarcia-test-tools

Internal tools for Eagle Eye Networks support and engineering operations — dashboards, Claude skills, and QA utilities.

---

## Quick Start — Dashboard Only

Just want the dashboard? This is all you need:

```bash
# 1. Clone
git clone https://github.com/agarciaEENswat/agarcia-test-tools.git
cd agarcia-test-tools

# 2. Install Flask
pip3 install flask

# 3. Add JIRA credentials to ~/.zshrc
echo "export JIRA_EMAIL='your-email@een.com'" >> ~/.zshrc
echo "export JIRA_API_TOKEN='your-api-token'" >> ~/.zshrc
source ~/.zshrc

# 4. Run
python3 scripts/ci-dashboard.py
```

Then open **http://localhost:8081**.

To generate a JIRA API token: [id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens) → **Create API token**.

---

## Quick Start — Morning Briefing Skill

Runs a full daily JIRA briefing and sends it to you as a Zulip DM.

**Requirements:** [Claude Code](https://claude.ai/code) must be installed.

```bash
# 1. Clone (skip if you already did this for the dashboard)
git clone https://github.com/agarciaEENswat/agarcia-test-tools.git
cd agarcia-test-tools

# 2. Copy scripts to ~/Scripts
mkdir -p ~/Scripts
cp scripts/jira-stalker.py ~/Scripts/jira-stalker.py
cp scripts/jira-account-backfill.py ~/Scripts/jira-account-backfill.py

# 3. Install the skill
mkdir -p ~/.claude/skills/morning-briefing
cp claude-skills/morning-briefing/SKILL.md ~/.claude/skills/morning-briefing/SKILL.md

# 4. Add credentials to ~/.zshrc
echo "export JIRA_EMAIL='your-email@een.com'" >> ~/.zshrc
echo "export JIRA_API_TOKEN='your-api-token'" >> ~/.zshrc
echo "export ZULIP_EMAIL='your-email@een.com'" >> ~/.zshrc
echo "export ZULIP_API_KEY='your-zulip-api-key'" >> ~/.zshrc
echo "export ZULIP_SITE='https://chat.eencloud.com'" >> ~/.zshrc
echo "export ZULIP_USER_ID='your-numeric-zulip-id'" >> ~/.zshrc
source ~/.zshrc

# 5. Edit the TEAM list in jira-stalker to match your support team
nano ~/Scripts/jira-stalker.py   # update the TEAM = [...] list at the top
```

Then in Claude Code, type:
```
/morning-briefing
```

**Where to find your credentials:**
- JIRA API token: [id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens)
- Zulip API key: chat.eencloud.com → Personal Settings → Account & Privacy → API key
- Zulip User ID: chat.eencloud.com/#settings/account (numeric ID in the URL or profile page)

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

### EEN Ops Dashboard

**File:** `scripts/ci-dashboard.py`

A local web dashboard with three tabs — customer-impact ticket health, a live VMSSUP support board view, and a morning briefing viewer.

![CI Dashboard](screenshots/ci-dashboard.png)

#### Tab 1 — Customer Impact

Shows the health of all open customer-impact tickets across EENS, EEPD, and Infrastructure.

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
| Needs Team Response | Surfaced from a loaded morning briefing MD file (see Tab 3) |

**Reporting section** (bottom of Tab 1):

| Section | Description |
|---------|-------------|
| Throughput | Opened vs closed per week, last 4 weeks — bar chart |
| Account Heat Map | Top accounts by open CI ticket count — click any row to see that account's tickets |
| Engineer Load | Combined CI + VMSSUP ticket count per person |
| Pipeline Health | Average ticket age per VMSSUP stage — shows where tickets are sitting longest |

All cards are **resizable** — drag the bottom-right corner. Sizes are saved to `localStorage` and restored on every load.

#### Tab 2 — VMSSUP Board

A live view of the VMSSUP support board, grouped by assignee. Mirrors what you'd see on the JIRA Kanban board but with stall detection added.

| Section | Description |
|---------|-------------|
| Stat tiles | Total open, Highest/High/Medium counts, Stalled ≥3d — all clickable to JIRA |
| Assignee rows | One row per assignee showing their tickets across all 4 active columns |
| Columns | Assistance/To-Do, Triage, Engineering, Support Review |
| Ticket cards | Priority-colored left border, summary, JIRA key, and age |
| Stalled section | High/Highest tickets with no update in ≥3 days |

Assignee rows are **collapsible** — click the row header to expand/collapse.

#### Tab 3 — Morning Briefing

Drop or browse a morning briefing `.md` file to view it rendered in the dashboard. Loading a file also:
- Shows a summary banner on the Customer Impact tab (CI total, out of spec count, needs-response counts)
- Injects a **Needs Team Response** card into the Customer Impact tab

See `examples/morning-briefing-example.md` for the expected file format.

**Setup:**

```bash
# Install dependencies
pip install -r scripts/requirements.txt

# Run
python3 scripts/ci-dashboard.py
```

Then open **http://localhost:8081** in your browser.

To run on a different port:
```bash
CI_DASH_PORT=9000 python3 scripts/ci-dashboard.py
```

---

### Morning Briefing (Claude Code Skill)

**File:** `claude-skills/morning-briefing/SKILL.md`

A Claude Code skill that runs a full daily JIRA briefing and sends it to Zulip as a DM. Also runs the account field backfill automatically before querying so the Account Heat Map is always fresh.

**What it covers:**

| Section | Description |
|---------|-------------|
| Account field backfill | Fills in missing account fields on CI tickets before running (see JIRA Account Backfill below) |
| New tickets since yesterday | New VMSSUP support tickets + new EEPD customer-impact tickets |
| High priority open | VMSSUP high/highest tickets, flagged if no movement in ≥3 days |
| Medium priority open | VMSSUP medium tickets, flagged if stalled ≥7 days |
| Total open customer impact | Age distribution chart with priority breakdown and delta vs. yesterday |
| Needs team response | Tickets waiting on a team reply, urgency-scored via jira-stalker |
| Out of spec work items | CI tickets violating SLA thresholds by priority |
| Sprint carry-over | Repeatedly punted / carried over / never in sprint breakdown |
| Open tickets by engineering team | Per-team CI ticket counts with High/Medium breakdown and deltas |
| Account field updates | Any tickets backfilled this run (only shown if > 0) |

Also generates a full markdown report saved to `~/Documents/Morning Briefing/` and uploads it as an attachment to the Zulip DM.

**Additional env vars required:**

```bash
export ZULIP_EMAIL='your-email@een.com'
export ZULIP_API_KEY='your-zulip-api-key'
export ZULIP_SITE='https://chat.eencloud.com'
export ZULIP_USER_ID='your-zulip-user-id'  # numeric ID, find at chat.eencloud.com/#settings/account
```

**How to run:**

In Claude Code, type:
```
/morning-briefing
```

**Install the skill:**

```bash
mkdir -p ~/.claude/skills/morning-briefing
cp claude-skills/morning-briefing/SKILL.md ~/.claude/skills/morning-briefing/SKILL.md
```

---

### JIRA Stalker

**File:** `scripts/jira-stalker.py`

Flags support tickets where the team hasn't responded recently. Groups results by last team member who commented, sorted by urgency score. Used by the morning briefing skill.

**Usage:**
```bash
python3 scripts/jira-stalker.py                  # check both queues, 2-day threshold
python3 scripts/jira-stalker.py --days 1         # stricter: flag after 1 day
python3 scripts/jira-stalker.py --prio high      # high priority only
python3 scripts/jira-stalker.py --prio medium
```

**Setup required:** Edit the `TEAM` list at the top of the script to match your support team members' JIRA display names:

```python
TEAM = [
    "Your Name",
    "Teammate Name",
    ...
]
```

The morning briefing skill expects this script at `~/Scripts/jira-stalker.py`:
```bash
cp scripts/jira-stalker.py ~/Scripts/jira-stalker.py
```

No additional dependencies — uses Python stdlib only.

---

### JIRA Account Backfill

**File:** `scripts/jira-account-backfill.py`

Finds open customer-impact CI tickets where the account custom fields (`customfield_11063` etc.) are empty, parses account info from the description text, and writes it back to the structured JIRA fields. This keeps the Account Heat Map accurate.

**Usage:**
```bash
python3 scripts/jira-account-backfill.py              # dry run — shows what would change
python3 scripts/jira-account-backfill.py --write      # apply changes
python3 scripts/jira-account-backfill.py --silent     # write + output JSON summary (used by morning briefing)
```

Always run a dry run first to review before writing.

The morning briefing skill runs this automatically with `--silent` on every briefing. If any tickets were backfilled, the briefing MD will include an **Account Field Updates** section listing what was changed.

**Install:**
```bash
cp scripts/jira-account-backfill.py ~/Scripts/jira-account-backfill.py
```

No additional dependencies — uses Python stdlib only.

---

## Full Setup Checklist

1. **Clone the repo**
2. **Set env vars** in `~/.zshrc` (JIRA + Zulip — see Prerequisites above)
3. **Install dashboard dependencies:** `pip install -r scripts/requirements.txt`
4. **Copy scripts to `~/Scripts/`:**
   ```bash
   mkdir -p ~/Scripts
   cp scripts/jira-stalker.py ~/Scripts/jira-stalker.py
   cp scripts/jira-account-backfill.py ~/Scripts/jira-account-backfill.py
   ```
5. **Edit `TEAM` list** in `~/Scripts/jira-stalker.py` with your team's JIRA display names
6. **Install morning briefing skill:**
   ```bash
   mkdir -p ~/.claude/skills/morning-briefing
   cp claude-skills/morning-briefing/SKILL.md ~/.claude/skills/morning-briefing/SKILL.md
   ```
7. **Run the dashboard:** `python3 scripts/ci-dashboard.py` → open http://localhost:8081
8. **Run a morning briefing:** In Claude Code, type `/morning-briefing`

---

## Repository Structure

```
agarcia-test-tools/
├── README.md
├── examples/
│   └── morning-briefing-example.md             # Example briefing file for the MD viewer
├── screenshots/
│   └── ci-dashboard.png
├── scripts/
│   ├── ci-dashboard.py                         # EEN Ops Dashboard (3 tabs)
│   ├── jira-stalker.py                         # Flags tickets with no team response
│   ├── jira-account-backfill.py               # Backfills account fields on CI tickets
│   └── requirements.txt                        # Python dependencies (Flask)
├── claude-skills/
│   └── morning-briefing/
│       └── SKILL.md                            # Claude Code morning briefing skill
├── qa-starter-kit/
│   └── README.md
└── Notes/
```

---

## License

Internal use for Eagle Eye Networks.
