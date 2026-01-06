# QA Test Plan - [Initiative Name] for [Platform: Web1/Web3/Mobile/Archiver]

## Revision History

| Date | Author | Status | Version |
|------|--------|--------|---------|
| MM/DD/YYYY | [Your Name] | TO DO / IN PROGRESS / IN REVIEW / BLOCKED / ON HOLD / DONE | 1.0 |

## Initiative

**Link**: [Link to Initiative/PRD/TRD]

---

## 1. Approvals

| Reviewer | Role | Review Date | Status |
|----------|------|-------------|--------|
| [Name] | QA Manager | | |
| [Name] | Code Team Lead | | |
| [Name] | Product Manager | | |

---

## 2. Test Setup

[Describe test environment, accounts, hardware, software requirements, etc.]

**Example**:
- Test Account: TS29 (US-HQ1-QA-LAB)
- Hardware: Bridges, cameras, devices
- Software: Application versions, browser versions
- Special setup requirements

---

## 3. Introduction

[Brief overview of what's being tested and why]

---

## 4. Test Scope

### Features To Be Tested (In-Scope)

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3

### Features Not To Be Tested (Out-of-Scope)

- [ ] Out of scope item 1
- [ ] Out of scope item 2

---

## 5. Test Strategy

### Test Assumptions

[List any assumptions being made about the feature, environment, or testing approach]

### Type of Testing

| Test Type | Responsible Parties |
|-----------|---------------------|
| Functional Testing | QA |
| Regression Testing | QA |
| Permission Based Testing | QA |
| Audit Log Based Testing | QA |
| Load & Performance Testing | QA/ENG |
| White Label Testing | QA |
| Parallel Testing | QA |

#### Functional Testing
[Specify test scenarios/use cases]

#### Regression Testing
[Specify test scenarios/use cases]

#### Permission Based Testing
[Specify test scenarios/use cases]

#### Audit Log Based Testing
[Specify test scenarios/use cases]

#### Load & Performance
[Specify test scenarios/use cases]

#### White Label
[Specify test scenarios/use cases]

#### Parallel Testing
[Specify test scenarios/use cases]

---

## 6. Schedule

| Task | Start Date | End Date |
|------|------------|----------|
| QA Test Schedule | MM/DD/YYYY | MM/DD/YYYY |
| Code Freeze Date | Not Applicable | MM/DD/YYYY |
| Production Deployment | Not Applicable | MM/DD/YYYY |

---

## 7. Execution Strategy

### Entry Criteria

| Entry Criteria | Status |
|----------------|--------|
| Test environment(s) is available | ✅/❌ |
| Test data is available | ✅/❌ |
| Development has completed unit testing (New Code Commit) | ✅/❌ |
| Test cases are completed, reviewed and approved by the Project Team | ✅/❌ |

### Exit Criteria

| Exit Criteria | Status |
|---------------|--------|
| 100% Test Cases executed | ✅/❌ |
| No Open Critical and High severity defects | ✅/❌ |
| No more than 10% of medium-severity bugs are open | ✅/❌ |

### Suspension Criteria

| Suspension Criteria | Status |
|---------------------|--------|
| Critical Bugs are open and they are blocking testing | ✅/❌ |
| All remaining test cases are blocked by an open bug | ✅/❌ |

---

## 8. Dependencies

[Identify any dependencies of testing, such as test-item availability, testing-resource availability, and deadlines]

**Example**:
- Dependent on Feature X being deployed
- Requires access to Production-like environment
- Waiting on hardware availability

---

## 9. Deliverable Checklist

| Item | Link | Owner | Status |
|------|------|-------|--------|
| Unit Testing Report | [Link] | ENG | ☐ Completed |
| Test Cases Created (QMetry) | [Link] | QA | ☐ Completed |
| Test Plan Review / Sign-off | [Link] | QA/ENG | ☐ Completed |
| Test Summary Report | [Link] | QA | ☐ Completed |
| Bug Report | [Link] | QA | ☐ Completed |

---

## 10. Resources Checklist

- [ ] TRD Link
- [ ] PRD Link
- [ ] Story Link
- [ ] Epic Link
- [ ] Github / PR Link
- [ ] Any Reference doc

---

## 11. Risks

| Risk | Mitigation |
|------|------------|
| QA team members lack required information about the feature | Plan knowledge sharing meetings with developers |
| Project schedule is too tight | Set Test Priority for each test activity |
| Lack of cooperation affects productivity | Daily meetings to encourage team members |
| [Add your risks] | [Add mitigation strategies] |

---

## Quick Copy-Paste Sections

### Common Test Scenarios

**Functional Testing**:
```
- User can [action] successfully
- System validates [field] correctly
- Error messages display appropriately
- UI elements render correctly across browsers
```

**Regression Testing**:
```
- Existing functionality still works
- No performance degradation
- Previously fixed bugs remain fixed
```

**Permission Testing**:
```
- Admin users can [action]
- Standard users cannot [action]
- Viewer-only users have read-only access
```
