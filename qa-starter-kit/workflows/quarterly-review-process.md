# Quarterly Review Process - SMART Accomplishments & Objectives

Guide for reviewing your work each quarter and setting SMART goals for the next quarter.

---

## Overview

**When**: Every ~90 days (your company's review cycle)
**Time needed**: 2-3 hours
**Output**: Document with Accomplishments (past 90 days) and Objectives (next 90 days)

**Note**: "Quarter" here means any 90-day review period, not necessarily Jan-Mar, Apr-Jun, etc.

---

## Step 1: Gather Your Data (30 minutes)

### Pull Your Jira Activity

Run these queries for the past 90 days (adjust dates to your review period):

**All bugs you filed in last 90 days**:
```bash
jira-bugs-filed-90days
```

**All tickets you created in last 90 days**:
```bash
jira-created-90days
```

**Tickets you worked on in last 90 days** (created, assigned, or updated):
```bash
jira-worked-90days
```

**Or use specific date ranges**:
```bash
jira-bugs-filed 2025-09-15 2025-12-15
jira-created-quarterly 2025-09-15 2025-12-15
```

### Search Your Confluence Contributions

**Test plans you created**:
- Go to: https://eagleeyenetworks.atlassian.net/wiki/spaces/ENG/pages/
- Filter by: Your name, Date range

**Documents you updated**:
- Check your Confluence profile for recent activity

### Review Your Calendar/Notes

- Major projects you worked on
- Initiatives you supported
- Meetings/presentations you led
- Training or mentoring you provided

---

## Step 2: Categorize Your Work (30 minutes)

Group your activities into categories:

### Testing & Quality
- Test plans created
- Test cases written
- Bugs filed (count by severity)
- Testing completed (features, regression, etc.)

### Process Improvements
- New processes implemented
- Documentation created
- Tools/scripts developed
- Training materials created

### Collaboration
- Cross-team projects
- Initiatives supported
- Knowledge sharing sessions

### Other Contributions
- Automation work
- Infrastructure improvements
- Special projects

---

## Step 3: Write SMART Accomplishments (45 minutes)

Transform your work into SMART accomplishments.

### SMART Format

**S**pecific - What exactly did you do?
**M**easurable - How much/many? What was the impact?
**A**chievable - Was it realistic and completed?
**R**elevant - How did it help the team/company?
**T**ime-bound - When did it happen?

### Template

```
[Action verb] [specific work] that [measurable result] to [business impact] during [timeframe]
```

### Examples

#### ❌ Bad (Not SMART)
- "Tested the gun detection feature"
- "Filed bugs"
- "Created test plans"
- "Helped the team"

#### ✅ Good (SMART)
- "Created comprehensive distance testing protocol (30-120ft with 24 test combinations) for Gun Detection AI that established performance baseline metrics for Q1 2026 Summit demo"

- "Filed 47 QA bugs (12 Critical, 18 High, 17 Medium) across WebUI and Mobile platforms during Q4 2025, with 89% resolved before release, improving product quality"

- "Developed QA Bug Report Template and published to Confluence with severity guidelines and examples, standardizing bug reporting process for 8-person QA team"

- "Led end-to-end testing for EEPD-70449 (Gun Detection QA) including hardware performance validation on 401AI bridges, enabling on-time release for December 2025"

- "Created and documented Jira API automation scripts that reduced quarterly review prep time from 4 hours to 30 minutes for entire QA team"

### Write Your Accomplishments

Aim for **5-8 accomplishments** per quarter. Focus on:
- Your biggest impacts
- Things that required significant effort
- Work that helped others
- Process improvements you made

---

## Step 4: Write SMART Objectives (45 minutes)

Set goals for the next quarter using SMART format.

### SMART Objectives Format

**S**pecific - Exactly what will you accomplish?
**M**easurable - How will you know you succeeded?
**A**chievable - Is it realistic in one quarter?
**R**elevant - Does it align with team/company goals?
**T**ime-bound - When will it be done?

### Template

```
[Action verb] [specific goal] by [deadline] to [achieve business outcome], measured by [metric]
```

### Examples

#### ❌ Bad (Not SMART)
- "Test more features"
- "Write better bugs"
- "Improve processes"
- "Help the team"

#### ✅ Good (SMART Objectives)
- "Execute distance testing protocol for 3 major AI features (Person Detection, Vehicle Detection, Animal Detection) by end of Q1 2026 to validate accuracy requirements before GA release"

- "Reduce critical bug escape rate from 8% to below 5% by implementing pre-release checklist and automated smoke tests by March 31, 2026"

- "Create and publish 4 additional QA templates (Test Summary Report, Test Case Guidelines, Release Checklist, Regression Test Suite) to Confluence by end of Q1 2026"

- "Achieve 100% test plan coverage for all Q1 2026 releases (minimum 3 features) by having approved test plans in Confluence at least 1 week before code freeze"

- "Mentor 2 new QA team members on Eagle Eye testing processes and tools, with both completing full feature testing independently by end of Q1 2026"

### Write Your Objectives

Aim for **3-5 objectives** per quarter. Consider:
- Team priorities for next quarter
- Your manager's expectations
- Skills you want to develop
- Process improvements needed
- Projects on the roadmap

---

## Step 5: Document in Standard Format (30 minutes)

### Review Template

```markdown
# Review Period: [Start Date] - [End Date] - [Your Name]
# Or: Q[X] 20XX - Quarterly Review - [Your Name] (if using calendar quarters)

## Accomplishments

### Testing & Quality
1. [SMART accomplishment]
2. [SMART accomplishment]

### Process Improvements
1. [SMART accomplishment]
2. [SMART accomplishment]

### Collaboration & Other
1. [SMART accomplishment]
2. [SMART accomplishment]

## Metrics Summary

### Bugs Filed
- Critical: X
- High: X
- Medium: X
- Low: X
- **Total: X**

### Testing Completed
- Test Plans Created: X
- Features Tested: X
- Regression Cycles: X

### Documentation
- Confluence Pages Created: X
- Confluence Pages Updated: X
- Templates Created: X

## Q[X+1] Objectives

1. [SMART objective]
2. [SMART objective]
3. [SMART objective]
4. [SMART objective]
5. [SMART objective]

## Notes
- Any blockers or challenges faced
- Support needed for next quarter
- Ideas for improvement
```

---

## Tips for Great Accomplishments

### Use Strong Action Verbs
- Created, Developed, Implemented, Executed
- Led, Managed, Coordinated, Facilitated
- Improved, Optimized, Streamlined, Enhanced
- Identified, Discovered, Resolved, Fixed
- Documented, Published, Trained, Mentored

### Include Numbers
- "47 bugs filed" not "many bugs"
- "30-120ft testing range" not "various distances"
- "89% resolution rate" not "most bugs fixed"
- "4 hours saved" not "faster process"

### Show Impact
- Don't just list what you did
- Explain why it mattered
- Connect to team/company goals
- Mention who benefited

### Be Honest
- Don't exaggerate
- Don't claim solo credit for team work
- Don't include incomplete work
- Don't pad with trivial items

---

## Tips for Great Objectives

### Align with Priorities
- Check team roadmap
- Talk to your manager
- Consider company OKRs
- Look at project timelines

### Be Realistic
- One quarter is ~13 weeks
- Account for other work
- Consider dependencies
- Leave buffer for unexpected work

### Make Them Measurable
- Include specific numbers
- Define clear success criteria
- Set concrete deadlines
- Use quantifiable metrics

### Focus on Impact
- Choose high-value work
- Pick things that matter
- Consider skill development
- Think about career growth

---

## Common Mistakes to Avoid

### Accomplishments
- ❌ Too vague: "Worked on testing"
- ✅ Specific: "Executed 156 test cases across 3 features"

- ❌ No numbers: "Found bugs"
- ✅ Measurable: "Filed 47 bugs with 89% resolved"

- ❌ No impact: "Created template"
- ✅ Shows value: "Created template that standardized process for 8-person team"

### Objectives
- ❌ No deadline: "Improve test coverage"
- ✅ Time-bound: "Achieve 90% test coverage by March 31"

- ❌ Not measurable: "Be better at testing"
- ✅ Measurable: "Reduce bug escape rate from 8% to 5%"

- ❌ Too broad: "Help with all testing"
- ✅ Specific: "Execute distance testing for 3 AI features"

---

## Review Schedule

**Your review cycle**: Every ~90 days based on your company's schedule

### How to Calculate Your 90-Day Period

Use rolling 90-day windows from whenever your review is due:
- If review is due Dec 15, 2025: Cover Sept 15 - Dec 15, 2025
- If review is due Mar 20, 2026: Cover Dec 20, 2025 - Mar 20, 2026

### Calendar Quarter Examples (if your company uses these)

**Q1 Review (End of March)**:
- Covers: Jan-Mar
- Objectives for: Apr-Jun

**Q2 Review (End of June)**:
- Covers: Apr-Jun
- Objectives for: Jul-Sep

**Q3 Review (End of September)**:
- Covers: Jul-Sep
- Objectives for: Oct-Dec

**Q4 Review (End of December)**:
- Covers: Oct-Dec
- Objectives for: Jan-Mar (next year)

---

## Sharing Your Review

### With Your Manager
- Schedule 1:1 meeting
- Send document 24 hours before
- Discuss accomplishments and objectives
- Get feedback and alignment
- Adjust objectives based on discussion

### With Your Team
- Optional: Share highlights in team meeting
- Celebrate big wins
- Inspire others
- Show what's possible

---

## Quick Start Checklist

- [ ] Run Jira queries for past 90 days (jira-bugs-filed-90days, jira-created-90days, jira-worked-90days)
- [ ] Search Confluence for your contributions
- [ ] Review calendar for major work
- [ ] Categorize work into buckets
- [ ] Write 5-8 SMART accomplishments
- [ ] Check team roadmap for next 90 days
- [ ] Write 3-5 SMART objectives
- [ ] Document in standard format
- [ ] Review with manager
- [ ] Save to file: `review-YYYY-MM-DD-[yourname].md` or `Q[X]-20XX-review-[yourname].md`

---

## Example Full Review

```markdown
# Q4 2025 - Quarterly Review - [Your Name]

## Accomplishments

### Testing & Quality
1. Created comprehensive distance testing protocol (30-120ft with 24 test combinations) for Gun Detection AI that established performance baseline metrics for Q1 2026 Summit demo

2. Filed 47 QA bugs (12 Critical, 18 High, 17 Medium) during Q4 2025 with 89% resolved before release, contributing to highest quality release of the year

3. Led end-to-end testing for EEPD-70449 (Gun Detection QA) including hardware performance validation on 401AI bridges, enabling on-time December 2025 release

### Process Improvements
4. Developed QA Bug Report Template and published to Confluence with severity guidelines and examples, standardizing bug reporting across 8-person QA team

5. Created Jira API automation scripts that reduced quarterly review prep from 4 hours to 30 minutes, saving 28 hours per year for QA team

6. Built QA Toolbox repository with 3 templates and command references, improving onboarding time for new QA team members by 50%

### Collaboration
7. Closed ticket EEPD-99075 (SMS validation for gun detection) confirming functionality works as designed for Summit 2025 demo

## Metrics Summary

### Bugs Filed
- Critical: 12
- High: 18
- Medium: 17
- Low: 0
- **Total: 47**

### Testing Completed
- Test Plans Created: 2
- Features Tested: 6
- Regression Cycles: 4

### Documentation
- Confluence Pages Created: 2
- Confluence Pages Updated: 5
- Templates Created: 3

## Q1 2026 Objectives

1. Execute distance testing protocol for 3 major AI features (Person Detection, Vehicle Detection, Animal Detection) by March 31, 2026 to validate accuracy requirements before GA release, measured by completion of 72 test combinations

2. Achieve 100% test plan coverage for all Q1 2026 releases (minimum 3 features) by having approved test plans in Confluence at least 1 week before code freeze for each release

3. Reduce critical bug escape rate from 8% to below 5% by implementing automated smoke test suite that runs pre-release by February 28, 2026

4. Create and publish 3 additional QA templates (Test Summary Report, Regression Checklist, Release Sign-off) to Confluence by March 15, 2026

5. Complete training on Selenium automation framework and implement 20 automated test cases for WebUI regression by end of Q1 2026

## Notes
- Distance testing framework created in Q4 can be reused for other AI features in Q1
- Need access to additional hardware for parallel testing in Q1
- Considering automation training to improve long-term efficiency
```

---

## Final Tips

**Start Early**: Don't wait until the last day of the quarter

**Keep Notes**: Track your accomplishments throughout the quarter

**Use Your Tools**: Leverage the Jira queries to gather data easily

**Be Proud**: You accomplish more than you think - write it down!

**Get Feedback**: Share drafts with your manager early

**Iterate**: Your first draft doesn't have to be perfect

**Save Examples**: Keep past reviews as templates for future ones
