# QA Toolbox Roadmap

## Vision
Create an easily imported QA toolbox with different markdowns - ultimately uploaded to git for easy handouts to the team.

## Core Problem
**Paperwork is the least fun part of the job, so it's often the least consistent and poorly done.**

## Solution
Make the boring paperwork:
- **Copy-paste ready** (minimal thinking required)
- **Quick reference** (not long docs to read)
- **Templates with examples** (modify, don't create from scratch)
- **Scripts/commands ready to run** (no setup needed)

---

## Repository Structure

```
qa-toolbox/
├── README.md
├── setup/
│   └── jira-setup-instructions.md
├── templates/
│   ├── test-plan-template.md
│   ├── bug-report-template.md
│   └── test-summary-template.md (TODO)
├── commands/
│   ├── jira-common-commands.md
│   └── confluence-commands.md (TODO)
├── workflows/
│   ├── quarterly-review-process.md
│   └── test-case-guidelines.md (TODO)
└── scripts/
    └── (helper scripts as needed)
```

---

## Completed

### ✅ Setup Documentation
- [x] Jira API Setup Guide (`jira-setup-instructions.md`)
  - Environment variable setup
  - Quick test commands
  - Common API examples

### ✅ Templates
- [x] Test Plan Template (`test-plan-template.md`)
  - Markdown version of Confluence template
  - All standard sections
  - Ready to copy/paste

- [x] Bug Report Template (`bug-report-template.md` + Confluence page)
  - QA_ prefix requirement
  - Severity/Priority guidelines
  - Component prefixes
  - Example bug reports (Critical, Medium, Low)
  - Checklist before submitting
  - Created Confluence page under Test Plan Template

- [x] Test Summary Report Template (`test-summary-report-template.md`)
  - Based on actual test report from Moving Accounts project
  - Includes Qmetry test cycle integration
  - Defects table with Jira API commands
  - Test accounts and devices sections
  - Pass/fail metrics summary
  - Sign-off section

---

### ✅ Commands & Queries
- [x] Common Jira Commands (`jira-common-commands.md`)
  - Basic ticket operations
  - Search queries
  - **Review period queries** (focus on what you MADE)
    - Bugs filed in last 90 days
    - Tickets created in last 90 days
    - Tickets worked on in last 90 days
    - Supports rolling 90-day windows and specific date ranges
    - Bash functions added to .bashrc

### ✅ Workflows
- [x] Quarterly Review Process (SMART A's & O's) (`quarterly-review-process.md`)
  - Reviewing Jira tickets each review period (90 days)
  - Creating SMART Accomplishments
  - Creating SMART Objectives for next period
  - Template for documenting A's & O's
  - Full example review with real accomplishments

### ✅ Repository Documentation
- [x] README.md
  - Quick start guide
  - What's included
  - Common use cases
  - Examples and tips

---

## TODO - High Priority

### Testing & Documentation
- [ ] Test Case Writing Guidelines
  - Format standards
  - What makes good test cases
  - Examples

### Tools & Scripts
- [ ] Confluence Access Patterns
  - Common queries for test plans
  - How to update documents
  - Searching Confluence

- [ ] Test Data Generation Scripts
  - Common test data needs
  - Quick setup scripts

### Workflows
- [ ] Release Testing Checklist
  - Pre-release testing steps
  - Sign-off checklist

- [ ] Regression Testing Guidelines
  - When to run regression
  - What to include

### Reference Materials
- [ ] Common Test Scenarios
  - Smoke tests
  - Sanity tests
  - Edge cases

- [ ] Edge Cases Checklist
  - Common edge cases to test
  - Boundary conditions

---

## TODO - Lower Priority

### Performance Testing
- [ ] Performance Testing Guidelines
  - What to measure
  - Tools to use
  - How to report results

### Security Testing
- [ ] Security Testing Basics
  - Common vulnerabilities to check
  - Tools and resources

### Process Documentation
- [ ] Onboarding Guide
  - New QA team member setup
  - Links to all resources

- [ ] QA Process Flow Diagrams
  - Visual workflows
  - How tickets flow through QA

---

## Team Pain Points to Address

1. **Paperwork is boring and inconsistent**
   - ✅ Templates make it copy-paste easy
   - ✅ Examples show what good looks like

2. **New people don't know how to access systems**
   - ✅ Jira setup guide
   - TODO: Confluence setup
   - TODO: Test management tool setup

3. **Inconsistent documentation**
   - ✅ Standard templates
   - TODO: Guidelines and examples

4. **Quarterly reviews are time-consuming**
   - In Progress: Query scripts to pull your work
   - In Progress: Template for A's & O's

5. **Finding past work is hard**
   - In Progress: Search queries
   - TODO: Better organization in Confluence

---

## Git Repository Plan

### Repository Name
`qa-toolbox` or `een-qa-toolkit`

### Branch Strategy
- `main` - stable, tested templates
- Feature branches for additions

### README Structure
```markdown
# QA Toolbox

Quick-start templates and tools for QA team

## Quick Start
1. Setup Jira access: [setup/jira-setup-instructions.md]
2. Use templates: [templates/]
3. Common commands: [commands/]

## What's Included
- Bug report template
- Test plan template
- Jira API commands
- Quarterly review process
...
```

### Distribution
- Clone repo to local machine
- Symlink templates to easy-access location
- Add bash aliases from setup guide

---

## Future Ideas

- VS Code snippets for common templates
- Browser bookmarklets for quick Jira operations
- Slack bot for common queries
- Dashboard showing team metrics
- Automated test report generation

---

## Success Metrics

How we'll know the toolbox is working:

1. **Adoption**
   - Team members using templates regularly
   - Fewer questions about "how do I..."

2. **Consistency**
   - Bug reports follow standard format
   - Test plans use same structure
   - QA_ prefix used consistently

3. **Time Savings**
   - Quarterly reviews faster
   - Less time formatting documents
   - Faster onboarding for new team members

4. **Quality**
   - More complete bug reports
   - Better documentation
   - Easier to find past work

---

## Notes

- Keep it simple - don't over-engineer
- Focus on copy-paste ready content
- Examples are better than explanations
- Update based on team feedback
- Version control everything
