# Test Report - [Feature/Epic Name]

## Summary

The objective of this testing cycle is to [describe what was being validated].

A total of **[X]** test cases were executed in the test environment, of which **[X]** have passed, **[X]** failed, and **[X]** were not executed. **[X]** bugs were found, **[X]** were deemed critical and resolved, and **[X]** will be resolved at a later date.

---

## Test Cycle Information

| Field | Details |
|-------|---------|
| **Report Date** | [Month DD, YYYY] |
| **Tested By** | [Your Name] |
| **Test Environment** | Production / Staging / QA |
| **Version/Build** | [Version number or build number] |
| **Test Cycle ID** | [Link to Qmetry Test Cycle](https://eagleeyenetworks.atlassian.net/plugins/servlet/ac/com.infostretch.QmetryTestManager/qtm4j-test-management?project.key=EEPD&project.id=10453#!/TestCycleDetail/[CYCLE_ID]?projectId=10453) |
| **EPIC** | [Link to JIRA Epic - EEPD-XXXXX](https://eagleeyenetworks.atlassian.net/browse/EEPD-XXXXX) |

---

## Blockers

[List any blockers encountered during testing, or state "No Blockers"]

Example:
- EEPD-12345 - Critical API endpoint down
- Waiting on environment access

OR

No Blockers

---

## QMetry Result Set

[Paste screenshots from Qmetry showing test execution results]

**How to get screenshots:**
1. Navigate to your Qmetry test cycle
2. Take screenshot of the test execution summary dashboard
3. Take screenshot of the test case list with pass/fail status
4. Paste images here or attach to Confluence

[Screenshot 1: Test Execution Dashboard]

[Screenshot 2: Test Case Results]

---

## Test Results Summary

| Metric | Count |
|--------|-------|
| **Total Number of Cases** | **[X]** |
| Passed | [X] |
| Failed | [X] |
| Not Executed | [X] |
| Blocked | [X] |

**Pass Rate**: [X]% (Passed / Total Executed)

---

## Defects Filed by QA Team

| Issue Key | Summary | Priority | Status |
|-----------|---------|----------|--------|
| [EEPD-XXXXX](https://eagleeyenetworks.atlassian.net/browse/EEPD-XXXXX) | [Bug description] | Critical / High / Medium / Low | Resolved / In Progress / To Do |
| [EEPD-XXXXX](https://eagleeyenetworks.atlassian.net/browse/EEPD-XXXXX) | [Bug description] | Critical / High / Medium / Low | Resolved / In Progress / To Do |
| [EEPD-XXXXX](https://eagleeyenetworks.atlassian.net/browse/EEPD-XXXXX) | [Bug description] | Critical / High / Medium / Low | Resolved / In Progress / To Do |

**How to populate this table:**

Run this command to get bugs you filed during the test period:
```bash
# For last 30 days
jira-bugs-filed $(date -d "30 days ago" +%Y-%m-%d) $(date +%Y-%m-%d)

# Or for specific date range
jira-bugs-filed 2025-11-01 2025-11-30
```

Then filter for bugs related to this feature/epic.

---

## Test Accounts and Devices Used

### Test Accounts

1. [Test Account Name - Link to EEN Admin](https://eenadmin.eagleeyenetworks.com/eenadmin/account_dashboard/XXXXXXXX/)
   - Account ID: [00XXXXXX]
   - Pod: [Pod name]
   - Purpose: [What this account was used for]

2. [Test Account Name - Link to EEN Admin](https://eenadmin.eagleeyenetworks.com/eenadmin/account_dashboard/XXXXXXXX/)
   - Account ID: [00XXXXXX]
   - Pod: [Pod name]
   - Purpose: [What this account was used for]

### Devices Used

**Account 1: [Account Name]**

| Make | Model | ESN | Notes |
|------|-------|-----|-------|
| Eagle Eye Networks | EN-CDUB-013-2 | 10027a7f | [Camera/Bridge notes] |
| [Make] | [Model] | [ESN] | [Notes] |

**Account 2: [Account Name]**

| Make | Model | ESN | Notes |
|------|-------|-----|-------|
| [Make] | [Model] | [ESN] | [Notes] |

---

## Additional Notes

[Any additional observations, recommendations, or follow-up items]

Example:
- Performance was slower than expected during peak load
- Recommend additional testing on mobile platforms
- Follow-up testing needed after EEPD-12345 is resolved

---

## Sign-Off

**Test Lead**: [Name]
**Date**: [Date]
**Status**: ✅ Ready for Release / ⚠️ Conditional Release / ❌ Not Ready

**Conditions (if applicable)**:
- [ ] All critical bugs must be resolved
- [ ] Performance issues addressed
- [ ] Additional regression testing completed

---

## Quick Reference - Commands to Help

### Get bugs you filed in date range
```bash
jira-bugs-filed 2025-11-01 2025-11-30
```

### Get all tickets you worked on
```bash
jira-worked-90days
```

### Search for bugs by epic
```bash
curl -s -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST "${JIRA_URL}/rest/api/3/search/jql" \
  -H "Content-Type: application/json" \
  -d '{
    "jql": "reporter=currentUser() AND \"Epic Link\"=EEPD-XXXXX AND issuetype=Bug",
    "fields": ["key", "summary", "priority", "status"],
    "maxResults": 100
  }' | python3 -m json.tool
```

Replace `EEPD-XXXXX` with your actual epic key.

---

## Tips for Completing This Template

1. **Summary Section**
   - Write this LAST after you know all the results
   - Keep it concise - 2-3 sentences max

2. **QMetry Screenshots**
   - Always include the test execution dashboard
   - Include the test case list showing pass/fail
   - Make sure screenshots are readable

3. **Defects Table**
   - Use Jira commands to pull bugs you filed during test period
   - Filter to only bugs related to this feature/epic
   - Update status column if bugs were resolved during testing

4. **Test Accounts**
   - Link to EEN Admin for easy access
   - Note which account was used for what purpose
   - Document any special configuration

5. **Devices Table**
   - Include ESN for traceability
   - Note firmware versions if relevant
   - Document any device-specific issues

6. **Sign-Off**
   - Be clear about readiness status
   - List any conditions that must be met
   - Include date for traceability
