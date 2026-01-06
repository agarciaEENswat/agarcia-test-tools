# QA Bug Report Template

## Quick Copy-Paste Format

Use this when creating a bug in Jira. Copy the entire block and fill in the details.

```
## Summary
[Brief one-line description of the bug]

## Environment
- **Platform**: Web1 / Web3 / Mobile (iOS/Android) / Bridge / Camera
- **Version/Build**: [e.g., v5.2.1, build 12345]
- **Browser** (if web): Chrome 120 / Firefox 115 / Safari 17
- **OS**: Windows 11 / macOS 14 / iOS 17 / Android 14
- **Test Account**: [e.g., TS29, TS01]
- **Bridge/Device ID** (if applicable): [e.g., 100bc1bb]
- **Camera ID** (if applicable): [e.g., 100f7de6]

## Severity/Priority
**Severity**: Critical / High / Medium / Low
**Priority**: Highest / High / Medium / Low

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [Third step]
4. [etc.]

## Expected Result
[What should happen]

## Actual Result
[What actually happens]

## Frequency
- [ ] Always (100%)
- [ ] Often (75%)
- [ ] Sometimes (50%)
- [ ] Rarely (25%)
- [ ] Once

## Screenshots/Logs
[Attach screenshots, error logs, console output, network traces]

## Additional Notes
[Any other relevant information, workarounds, related tickets]
```

---

## Severity Guidelines

Use these guidelines to determine bug severity:

### Critical
- **System crash** or complete failure
- **Data loss** or corruption
- **Security vulnerability**
- **Production blocker** - cannot deploy
- **No workaround** exists

**Examples**:
- Application crashes on launch
- User data is deleted unexpectedly
- Authentication completely broken
- Bridge goes offline and cannot reconnect

### High
- **Major feature broken** or unusable
- **Significant impact** on user experience
- **Workaround exists** but difficult
- **Blocks testing** of related features

**Examples**:
- Video playback fails for all cameras
- Cannot create alert rules
- Gun detection not triggering events
- Camera settings not saving

### Medium
- **Minor feature broken** or degraded
- **Some impact** on user experience
- **Easy workaround** exists
- **Does not block** major workflows

**Examples**:
- UI element misaligned
- Minor visual glitch
- Feature works but with extra steps
- Tooltip text incorrect

### Low
- **Cosmetic issues** only
- **Minimal impact** on user experience
- **Enhancement** or improvement suggestion
- **Edge case** scenario

**Examples**:
- Typo in text
- Color slightly off
- Minor spacing issue
- Feature request

---

## Priority Guidelines

Priority indicates **how soon** the bug should be fixed (separate from severity).

| Priority | When to Use |
|----------|-------------|
| **Highest** | Critical bug blocking release, production issue affecting customers |
| **High** | Important bug that should be fixed before release |
| **Medium** | Should be fixed but can wait for next sprint/release |
| **Low** | Nice to fix eventually, low impact |

**Note**: A **Low Severity** bug can have **High Priority** if it affects a key demo or launch event.

---

## Bug Title Format

**ALWAYS use QA_ prefix and component prefix:**

Format: `QA_[Component] - [Brief description]`

### Standard Component Prefixes

- `QA_WebUI -` Web interface issues
- `QA_Mobile -` Mobile app issues (iOS/Android)
- `QA_Bridge -` Bridge-related issues
- `QA_Camera -` Camera-related issues
- `QA_API -` API endpoint issues
- `QA_Gun Detection -` Gun detection specific
- `QA_Alerts -` Alert/automation issues
- `QA_Playback -` Video playback issues
- `QA_Search -` Search functionality issues
- `QA_Auth -` Authentication/login issues

**Example**: `QA_WebUI - Gun detection events not displaying in History Browser`

**Rules**:
- ❌ No customer names in title
- ✅ Keep it concise (under 100 characters)
- ✅ Be specific about what's broken

---

## Checklist Before Submitting

Before you create the bug, verify:

- [ ] **Can you reproduce it?** Try at least twice
- [ ] **Clear steps?** Can someone else follow them?
- [ ] **Screenshots attached?** Visual proof helps
- [ ] **Logs included?** Console errors, network traces
- [ ] **Environment specified?** Browser, OS, build version
- [ ] **Not a duplicate?** Search existing bugs first
- [ ] **Title is clear?** Uses QA_ and component prefix, no customer names
- [ ] **Severity/Priority set?** Based on guidelines above

---

## Example Bug Reports

### Example 1: Critical Bug

```
Title: QA_WebUI - Application crashes when opening History Browser

## Summary
Web application crashes completely when clicking on History Browser tab

## Environment
- Platform: Web3
- Version: v5.2.1
- Browser: Chrome 120
- OS: Windows 11
- Test Account: TS29

## Severity/Priority
Severity: Critical
Priority: Highest

## Steps to Reproduce
1. Login to Web3 application
2. Navigate to any camera
3. Click on "History Browser" tab
4. Application crashes immediately

## Expected Result
History Browser should load and display timeline

## Actual Result
Application crashes with white screen, console shows error:
"TypeError: Cannot read property 'timestamp' of undefined"

## Frequency
- [x] Always (100%)

## Screenshots/Logs
[Attach console screenshot showing error]

## Additional Notes
Blocking all QA testing of history playback features
```

### Example 2: Medium Bug

```
Title: QA_Gun Detection - Event thumbnail shows wrong timestamp

## Summary
Gun detection event thumbnails display timestamp that is 5 seconds earlier than actual event time

## Environment
- Platform: Web3
- Version: v5.2.1
- Browser: Chrome 120
- OS: macOS 14
- Test Account: TS01
- Camera ID: 100f7de6
- Bridge: 401AI (100bc1bb)

## Severity/Priority
Severity: Medium
Priority: High (Summit demo)

## Steps to Reproduce
1. Enable gun detection on camera 100f7de6
2. Trigger a gun detection event at 10:00:00 AM
3. Navigate to Automations > Recent Alerts
4. Observe event thumbnail timestamp

## Expected Result
Thumbnail should show timestamp: 10:00:00 AM

## Actual Result
Thumbnail shows timestamp: 9:59:55 AM (5 seconds earlier)

## Frequency
- [x] Always (100%)

## Screenshots/Logs
[Screenshot comparing event time in logs vs thumbnail display]

## Additional Notes
- Event time in database is correct (verified with API query)
- Issue appears to be UI display only
- Related to EEPD-70449
```

### Example 3: Low Bug

```
Title: QA_WebUI - Button text has typo on Settings page

## Summary
"Camrea Settings" button has typo, should be "Camera Settings"

## Environment
- Platform: Web3
- Version: v5.2.1
- Browser: All browsers
- Test Account: Any

## Severity/Priority
Severity: Low
Priority: Low

## Steps to Reproduce
1. Login to Web3
2. Navigate to Settings
3. Look at camera configuration section

## Expected Result
Button text: "Camera Settings"

## Actual Result
Button text: "Camrea Settings"

## Frequency
- [x] Always (100%)

## Screenshots/Logs
[Screenshot of button with typo]

## Additional Notes
Simple typo fix, cosmetic only
```

---

## Quick Jira Fields Reference

When creating a bug in Jira, fill these standard fields:

| Field | What to Put |
|-------|-------------|
| **Project** | EEPD (or appropriate project) |
| **Issue Type** | Bug |
| **Summary** | QA_[Component] - Description |
| **Priority** | Highest/High/Medium/Low |
| **Description** | Use template above |
| **Assignee** | Leave blank (triage will assign) |
| **Labels** | Add relevant: GunDetection, WebUI, Mobile, etc. |
| **Affects Version** | Build/version where bug found |
| **Component** | Select affected component |
| **Attachment** | Screenshots, logs, videos |

---

## Pro Tips

### Speed Up Bug Reporting

**Use browser extensions**:
- Loom/Awesome Screenshot - Quick screen recordings
- Chrome DevTools - Copy network traces
- JSONView - Pretty print API responses

**Create templates**:
- Save common bug formats in text expander
- Keep standard test account info handy
- Pre-fill environment details for your setup

**Keyboard shortcuts**:
- `Ctrl+Shift+I` - Chrome DevTools
- `Ctrl+Shift+C` - Element inspector
- `F12` - Console (most browsers)

### What NOT to Include

- ❌ Customer names in title (use in description if needed)
- ❌ Vague descriptions like "doesn't work"
- ❌ Assumptions about root cause
- ❌ Multiple bugs in one ticket
- ❌ Feature requests disguised as bugs

### What Makes a GREAT Bug Report

- ✅ Clear, specific title with QA_ prefix
- ✅ Exact reproduction steps
- ✅ Screenshots showing the issue
- ✅ Console logs if applicable
- ✅ Frequency information
- ✅ All environment details
- ✅ Expected vs actual clearly stated

---

## Common Scenarios

### When You Find Multiple Related Bugs

Create separate tickets, then link them:
1. File Bug A
2. File Bug B
3. In Bug B description: "Related to EEPD-12345"
4. Use Jira "Relates to" link type

### When You're Not Sure If It's a Bug

Ask yourself:
- Is this documented behavior? → Not a bug (maybe enhancement)
- Does it match the PRD/spec? → If no, it's a bug
- Would a user expect this? → If no, probably a bug

When in doubt, file it and let triage decide.

### When Bug is Intermittent

- Document the frequency
- Note any patterns (time of day, specific actions)
- Try to find a reliable reproduction path
- If you can't reproduce reliably, note that clearly
- Attach any logs from when it occurred

---

## Save Time: Common Bug Report Snippets

### Web Console Error
```
Console Error:
[Timestamp] [Error Level] Message
Stack trace:
  at function (file.js:line:col)
```

### Network Request Failed
```
Request:
GET https://api.eagleeyenetworks.com/endpoint
Status: 500 Internal Server Error

Response:
{error details}
```

### Camera/Bridge Info Block
```
Device Information:
- Bridge ID: 100bc1bb
- Bridge Type: 401AI
- Firmware: v3.2.1
- Camera ID: 100f7de6
- Camera Model: DB11
- Connection: Online
```
