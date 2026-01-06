# Customer Impact Troubleshooting Runbook

**Based on analysis of 500 customer-impact Jira tickets** **Projects:** EEPD, EENS, Infrastructure | **Types:** Bugs & Problems only **JQL Query:** project in (EEPD,Infrastructure,EENS) AND labels in (customer-impact) AND issuetype not in (Improvement, story) **Last Updated:** 2025-12-17

---

## Table of Contents

0. [Quick Resolution Patterns](#bookmark=id.nmsekfkepdlu) ⭐ **START HERE**

1. [Camera Issues](#bookmark=id.sg9mom2m7f8u)

2. [Video Playback Issues](#bookmark=id.b3iwigupi1i)

3. [Offline/Connectivity Issues](#bookmark=id.grwyypstp63x)

4. [Bridge Issues](#bookmark=id.yebeiz72e06a)

5. [LPR Issues](#bookmark=id.y95wfufhei3e)

6. [Event/Webhook Issues](#bookmark=id.gi460w4oi0q7)

7. [UI/Dashboard Issues](#bookmark=id.87vc6wrz9hig)

8. [Retention/Storage Issues](#bookmark=id.hhuezg3m0pvz)

9. [Common Diagnostic Commands](#bookmark=id.nsozuxv5q0o7)

10. [Escalation Paths](#bookmark=id.nk6tc229jj9j)

---

## Overview Statistics

### 🎯 Key Insights from 500 Properly Filtered Tickets

* **Project Distribution:** 76% EEPD, 21% EENS, 3% Infrastructure

* **Issue Types:** 78% Bugs, 21% Problems

* **\#1 Most Common Issue:** Devices/Cameras Showing Offline (60 tickets, 12%)

* **Top 3 Affected Components:**

  1. Cameras (105 tickets, 21%)

  2. Bridge/CMVR (95 tickets, 19%)

  3. VMS Interface (80 tickets, 16%)

### 🔴 Top 20 Customer Symptoms (What Users Actually Report)

1. **Devices/Cameras Showing Offline** \- 60 tickets (12%)

2. **Operation Failures** \- 45 tickets (9%)

3. **System Crashes** \- 40 tickets (8%)

4. **Loading Issues** \- 35 tickets (7%)

5. **Video Playback Issues** \- 35 tickets (7%)

6. **Unable to Perform Action** \- 30 tickets (6%)

7. **Error Messages** \- 30 tickets (6%)

8. **Missing Data/Content** \- 20 tickets (4%)

9. **Login Problems** \- 15 tickets (3%)

10. **Unplayable Video** \- 10 tickets (2%)

11. **Buffering Issues** \- 10 tickets (2%)

12. **Performance/Speed Issues** \- 10 tickets (2%)

13. **Display Issues** \- 10 tickets (2%)

14. **Deletion Issues** \- 10 tickets (2%)

15. **Incorrect Data Display** \- 5 tickets (1%)

16. **Feature Not Working** \- 5 tickets (1%)

17. **Video Gaps/Missing Footage** \- 5 tickets (1%)

18. **Loading Failures** \- 5 tickets (1%)

19. **Access/Permission Issues** \- 5 tickets (1%)

20. **Freezing/Hanging** \- 5 tickets (1%)

### 🔧 Top 20 Affected Components

1. **Cameras** \- 105 tickets (21%)

2. **Bridge/CMVR** \- 95 tickets (19%)

3. **VMS Interface** \- 80 tickets (16%)

4. **Events/Webhooks** \- 40 tickets (8%)

5. **History/Timeline** \- 40 tickets (8%)

6. **LPR (License Plate)** \- 40 tickets (8%)

7. **Notifications** \- 30 tickets (6%)

8. **Retention/Storage** \- 25 tickets (5%)

9. **Downloads** \- 25 tickets (5%)

10. **Video Footage** \- 25 tickets (5%)

11. **Recording** \- 20 tickets (4%)

12. **Live Preview** \- 15 tickets (3%)

13. **Search** \- 15 tickets (3%)

14. **Dashboard Rollup** \- 10 tickets (2%)

15. **Analytics** \- 10 tickets (2%)

16. **Layouts** \- 10 tickets (2%)

17. **Branding** \- 5 tickets (1%)

18. **Snapshots** \- 5 tickets (1%)

19. **Streaming** \- 5 tickets (1%)

20. **Webhooks** \- (included in Events/Webhooks)

### ⚠️ Common Error Codes

* **HTTP 422:** 10 occurrences (unprocessable content \- often video/playback issues)

* **HTTP 404:** 10 occurrences (device not found, API endpoint issues)

* **HTTP 504:** 5 occurrences (gateway timeout)

* **HTTP 500:** 5 occurrences (internal server error)

### Most Common Resolution Methods (from resolved tickets)

* **Configuration Fixes:** 53% of resolutions

* **Network Fixes:** 47% of resolutions

* **API Debugging:** 22% of resolutions

* **Permission/Auth Fixes:** 22% of resolutions

* **Etag Sync Fixes:** 16% of resolutions

* **Cache/Refresh Fixes:** 12% of resolutions

* **Backend/Database Fixes:** 10% of resolutions

---

## Quick Resolution Patterns

Based on analysis of 51 resolved tickets, here are the most common fixes:

### Troubleshooting Flowchart

START: Customer reports issue  
    ↓  
1\. Can you reproduce the issue?  
    NO → Ask for specific steps, screenshots, timestamps  
    YES → Continue  
    ↓  
2\. Check recent deployments/changes  
    Recent change? → Check release notes, known issues  
    ↓  
3\. Identify issue category (see statistics above)  
    ↓  
4\. Try most common fix for that category:  
    \- Config issues (53%) → Check settings in both interfaces  
    \- Network issues (47%) → Verify VLAN, cables, connectivity  
    \- API issues (22%) → Test API endpoints  
    \- Auth issues (22%) → Check permissions, SSO  
    \- Etag sync (16%) → Initiate sync in Nexus  
    \- Cache (12%) → Clear cache, force refresh  
    \- Backend (10%) → Check for orphaned records, escalate  
    ↓  
5\. Issue resolved?  
    YES → Document resolution, update runbook if new pattern  
    NO → Try next most likely fix OR escalate

---

### 1\. Configuration Issues (53% of resolutions)

**When to suspect:** Settings mismatches, inconsistent behavior between interfaces, features not working as expected

**Common fixes:** \- Verify settings in both Classic and Enhanced interfaces \- Check for stale configuration cache \- Confirm backend configuration via API calls \- Review account-level vs device-level settings hierarchy

**Example tickets:** EENS-133059, EEPD-95638, EEPD-103382

### 2\. Network Issues (47% of resolutions)

**When to suspect:** Connectivity problems, intermittent failures, VLAN-related issues

**Common fixes:** \- Check VLAN configuration and separation (CamLan vs other VLANs) \- Verify physical cable connections \- Review switch configuration \- Check PoE power delivery \- Test bandwidth and network saturation

**Example tickets:** EENS-133007, EEPD-106093, EEPD-95638

### 3\. API/Integration Issues (22% of resolutions)

**When to suspect:** 404 errors, missing data in API responses, orphaned records

**Common fixes:**

*\# Verify device appears in API*  
curl \-X GET "https://\[domain\]/g/web/list/devices" \-H "Authorization: Bearer \[token\]"

*\# Check specific device*  
curl \-X GET "https://\[domain\]/g/device/\[deviceId\]" \-H "Authorization: Bearer \[token\]"

*\# Review API response for missing fields*

**Example tickets:** EEPD-106093, EENS-133064, EEPD-104743

### 4\. Permission/Auth Issues (22% of resolutions)

**When to suspect:** Login problems, access denied, SSO issues, feature access problems

**Common fixes:** \- Verify user permissions and role assignments \- Check SSO configuration and enforcement \- Test with password reset \- Review account hierarchy and inheritance \- Verify API token validity and scope

**Example tickets:** EENS-133007, EEPD-104743, EEPD-102359

### 5\. Etag Sync Issues (16% of resolutions)

**When to suspect:** Video status mismatches, history playback showing wrong status, footage appears offline

**Common fixes:** \- Initiate full etag sync in Nexus for affected camera \- Wait for sync completion (monitor progress) \- Verify etags are in sync between systems \- Re-check video history after sync completes

**Example tickets:** EENS-133087, EEPD-95638, EEPD-105893

### 6\. Cache/Refresh Issues (12% of resolutions)

**When to suspect:** Stale data displayed, settings not updating, inconsistent UI behavior

**Common fixes:** \- Clear browser cache \- Force hard refresh (Ctrl+Shift+R / Cmd+Shift+R) \- Clear application cache server-side \- Force config reload from backend

**Example tickets:** EENS-133087, EENS-133021, INFRA2-9313

### 7\. Backend/Database Issues (10% of resolutions)

**When to suspect:** Orphaned records, data inconsistencies, cascading failures

**When this requires escalation:** \- Manual database cleanup needed \- Orphaned device records not in API \- Data integrity issues across multiple systems

**Example tickets:** EEPD-106093, EEPD-102359, EEPD-105251

---

## 1\. Camera Issues

### Common Symptoms

* Camera showing offline when actually online

* Unable to add camera to layout (404 errors)

* Camera appearing twice in system

* Preview freezing

* Camera status mismatches between Classic/Enhanced interfaces

### Troubleshooting Steps

#### *Camera Shows Wrong “Offline” Status*

**Reference:** EENS-133087, EEPD-95638

1. **Check etag sync status**

* *\# Initiate full etag sync in Nexus for the camera*  
  *\# Check if etags are in sync*

2. **Verify camera connectivity**

   * Check if camera is actually accessible

   * Verify network connectivity

   * Check bridge connection if applicable

3. **Review camera history**

   * After etag sync completes, check if history reports correctly

   * Look for timestamp inconsistencies

#### *Unable to Add Camera to Layout (404 Error)*

**Reference:** EENS-133088

1. **Check for duplicate camera entries**

* *\# Look for camera appearing twice in device list*  
  *\# Check web-cpsgtd errors*

2. **Verify camera device ID**

   * Confirm camera is properly registered

   * Check if device appears in /g/web/list/devices call

3. **Review error logs**

   * Look for specific device ID in error messages

   * Check for orphaned camera references

#### *Camera Preview Freezing*

**Reference:** EEPD-103382

1. **Check network configuration**

   * Verify VLAN settings (ensure camera is on correct VLAN)

   * Check for mixed VLAN configurations on switches

   * Verify CamLan VLAN separation

2. **Check cabling**

   * Verify physical network connections

   * Look for cable issues between camera and switch

3. **Review bandwidth**

   * Check network saturation

   * Verify PoE power delivery

---

## 2\. Video Playback Issues

### Common Symptoms

* History playback buffers continuously

* Unable to play or download footage

* Playback freezes at specific timestamps

* 422 errors during playback

* Wrong status displayed for footage

### Troubleshooting Steps

#### *History Playback Buffering*

**Reference:** EEPD-101298, EEPD-106090

1. **Check timestamp errors**

   * Look for 422 errors in logs

   * Verify timestamp validity

2. **Review cluster performance**

   * Check cluster load

   * Verify storage cluster health

3. **Check camera recording status**

   * Ensure continuous recording

   * Look for gaps in footage

#### *Playback Freezes at Specific Timestamp*

**Reference:** EEPD-104684

1. **Identify problematic timestamp**

   * Note exact freeze time

   * Check for corruption at that point

2. **Check video file integrity**

   * Verify file completeness

   * Look for encoding errors

3. **Review storage logs**

   * Check for disk errors during that timeframe

   * Look for write failures

#### *Unable to Play/Download Footage*

**Reference:** EEPD-105360

1. **Verify footage exists**

   * Check retention period

   * Confirm recording was active

2. **Check permissions**

   * Verify user access rights

   * Check account permissions

3. **Test API calls**

* *\# Test footage retrieval API*  
  *\# Verify response codes*

---

## 3\. Offline/Connectivity Issues

### Common Symptoms

* Devices showing offline in rollup/dashboard

* “Internet offline” status when device is online

* Unable to tunnel using satellite icon

* Multiple accounts/clusters affected

### Troubleshooting Steps

#### *Reseller Rollup Showing Devices Offline*

**Reference:** EEPD-106192

1. **Check rollup timing**

* *\# Access Grafana dashboard*  
  *\# https://graphs.eencloud.com/d/ae6dc5zpyowe8a/noc3a-reseller-rollup-refresh-lag*  
  *\# Verify rollup refresh lag is normal*

2. **Verify device actual status**

   * Check individual device connectivity

   * Compare Classic vs Enhanced interface status

3. **Check cluster health**

   * Verify cluster is responding

   * Check for cluster-wide issues

#### *Cameras Showing Internet Offline but Actually Online*

**Reference:** EENS-133086

1. **Check cluster assignment**

   * Verify correct cluster (e.g., c031-aus2p1)

   * Check cluster status

2. **Test tunneling**

   * Attempt satellite icon tunnel

   * Check for proxy/firewall issues

3. **Review bridge connectivity**

   * If bridge-connected, check bridge status

   * Verify bridge network connectivity

---

## 4\. Bridge Issues

### Common Symptoms

* Bridge failures in short timeframe

* Unable to delete bridge (404 errors)

* Bridge not appearing in device list

* CMVR issues

### Troubleshooting Steps

#### *Multiple Bridge Failures*

**Reference:** EENS-133007

1. **Review bridge logs**

* *\# Pull bridge logs using /pull-logs command*  
  journalctl \--since "YYYY-MM-DD" \--until "YYYY-MM-DD"

2. **Check for software issues**

   * Review recent firmware updates

   * Look for version 3.7.3 issues or similar

   * Check for storage-related problems

3. **Analyze failure patterns**

   * Check if failures are correlated

   * Look for common timeframes

   * Review system load during failures

#### *Unable to Delete Bridge (404 Error)*

**Reference:** EENS-133064

1. **Check device list API**

* *\# Verify bridge appears in /g/web/list/devices call*  
  *\# If missing, bridge metadata is orphaned*

2. **Review bridge registration**

   * Check if bridge is properly registered

   * Look for orphaned database entries

3. **Manual cleanup (if necessary)**

   * Contact backend team for manual deletion

   * Document ESN and account details

---

## 5\. LPR Issues

### Common Symptoms

* Access granted to unauthorized vehicles

* LPR events not displaying in VSP

* Unable to disable Cloud LPR

* LPR setting discrepancies between Classic/Enhanced

* Expired credentials still granting access

### Troubleshooting Steps

#### *Unauthorized Vehicle Access*

**Reference:** EEPD-105713

1. **Review LPR configuration**

   * Check vehicle credentials list

   * Verify expiration dates are enforced

2. **Check LPR event logs**

   * Review recent access grants

   * Look for pattern in unauthorized access

3. **Verify access control rules**

   * Ensure rules are properly configured

   * Check for rule conflicts

#### *LPR Events Not Displaying in VSP*

**Reference:** EEPD-105893

1. **Check event ingestion**

   * Verify cloudLPR events are being ingested

   * Look for ingestion errors

2. **Review event dates**

   * Confirm events are within expected timeframe

   * Check for date/timezone issues

3. **Force event reingestion (if needed)**

   * Contact backend team to reingest events

   * Document camera ESN and timeframe

#### *Unable to Disable Cloud LPR*

**Reference:** EEPD-106093

1. **Check API response**

* *\# Make API call to disable LPR*  
  *\# Review response for errors*

2. **Review vlogs**

* *\# https://vlogs.eencloud.com/select/vmui/\#/?query=...*  
  *\# Look for errors in LPR configuration calls*

3. **Verify interface parity**

   * Check if issue exists in both Classic and Enhanced

   * Try disabling from alternate interface

#### *LPR Setting Discrepancy (Classic vs Enhanced)*

**Reference:** EEPD-105113

1. **Compare settings in both interfaces**

   * Document exact differences

   * Check which setting is correct

2. **Verify backend state**

   * Check actual camera configuration via API

   * Determine which interface is showing stale data

3. **Force cache refresh**

   * Clear cache if applicable

   * Force settings reload

---

## 6\. Event/Webhook Issues

### Common Symptoms

* Issues retrieving event subscriptions

* Video gaps without corresponding events

* Webhook delivery failures

* Event notification problems

### Troubleshooting Steps

#### *Issues Retrieving Event Subscriptions*

**Reference:** EEPD-105652

1. **Check subscription endpoint**

* *\# Test webhook endpoint connectivity*  
  *\# Verify endpoint is accessible*

2. **Review subscription configuration**

   * Verify webhook URL is valid

   * Check authentication settings

3. **Check event logs**

   * Look for failed delivery attempts

   * Review error messages

#### *Video Gaps Without Events*

**Reference:** EEPD-102531

1. **Check recording status during gap**

   * Verify camera was online

   * Check for bridge connectivity issues

2. **Review event generation**

   * Check if events should have been generated

   * Look for event processing errors

3. **Analyze gap timeframe**

   * Check for system maintenance

   * Look for cluster issues during timeframe

---

## 7\. UI/Dashboard Issues

### Common Symptoms

* Dashboard rollup count discrepancies

* History playback issues in interface

* Unexpected auto logout

* Login redirecting to wrong page

* Branding missing

### Troubleshooting Steps

#### *Dashboard Rollup Count Discrepancies*

**Reference:** EEPD-100932

1. **Compare Classic vs Enhanced counts**

   * Document exact differences

   * Identify which is correct

2. **Check rollup calculation**

   * Verify rollup logic

   * Look for filtering differences

3. **Review account hierarchy**

   * Check if sub-accounts are counted correctly

   * Verify device attribution

#### *Unexpected Auto Logout During Active Sessions*

**Reference:** EEPD-105151

1. **Check session timeout settings**

   * Verify session duration configuration

   * Look for premature timeout

2. **Review authentication logs**

   * Look for session invalidation events

   * Check for security-related logouts

3. **Test reproducibility**

   * Document exact user actions before logout

   * Check for pattern (e.g., specific page, action)

#### *Login Redirecting to Wrong Page*

**Reference:** EEPD-106269

1. **Check login search functionality**

   * Verify search query parameters

   * Test with different account types

2. **Review redirect logic**

   * Check for URL parameter issues

   * Verify routing configuration

3. **Test with different users**

   * Check if issue is user-specific

   * Verify permissions impact

---

## 8\. Retention/Storage Issues

### Common Symptoms

* Incorrect retention settings displayed

* Unwanted assets retained in local storage

* Storage quota exceeded

* Retention discrepancies between interfaces

### Troubleshooting Steps

#### *Incorrect Retention Settings Displayed*

**Reference:** EEPD-105896

1. **Check actual retention configuration**

* *\# Query retention settings via API*  
  *\# Compare to displayed values*

2. **Verify account-level settings**

   * Check master account retention

   * Verify sub-account overrides

3. **Check for display bugs**

   * Test in both Classic and Enhanced

   * Document which shows correct values

#### *CMVR \- Unwanted Assets Retained*

**Reference:** EEPD-105873

1. **Review local storage contents**

   * Check what assets are stored

   * Identify unwanted/old assets

2. **Check retention policy**

   * Verify local retention settings

   * Check for policy enforcement

3. **Manual cleanup if needed**

   * Document assets to be removed

   * Coordinate with customer for cleanup window

---

## Common Diagnostic Commands

### Bridge Diagnostics

*\# Pull bridge logs*  
/pull-logs \<ESN\>

*\# Check bridge status*  
journalctl \--list-boots

*\# View recent logs*  
journalctl \--since "YYYY-MM-DD HH:MM:SS" \--until "YYYY-MM-DD HH:MM:SS"

*\# Check for blocked tasks*  
journalctl **|** grep "blocked for more than"

*\# Check RAID status (if applicable)*  
cat /proc/mdstat  
mdadm \--detail /dev/md127

*\# Check for kernel panics or hardware issues*  
journalctl \-k **|** grep \-i "error\\|fail\\|panic"

### API Testing

*\# List all devices for an account*  
curl \-X GET "https://\[domain\]/g/web/list/devices" \\  
  \-H "Authorization: Bearer \[token\]"

*\# Check specific camera status*  
curl \-X GET "https://\[domain\]/g/device/\[deviceId\]" \\  
  \-H "Authorization: Bearer \[token\]"

*\# Review event subscriptions*  
curl \-X GET "https://\[domain\]/api/v3.0/eventSubscriptions" \\  
  \-H "Authorization: Bearer \[token\]"

*\# Search device registry (for troubleshooting orphaned devices)*  
*\# Example from EENS-133064*  
curl "https://registry.\[cluster\].eencloud.com/api/v2/Search?Include=czts\&Device\_in=\[deviceId\]"

*\# Check dhash for device records (backend debugging)*  
*\# Example from EENS-133064*  
curl "https://dproxy.test.eencloud.com/api/v2/dhash/node/v1/com.eencloud.dhash.esn:\[accountId\]:devices"

*\# Get camera analytics settings*  
curl "https://api.\[cluster\].eagleeyenetworks.com/api/v3.0/cameras/\[cameraId\]" \\  
  \-H "Authorization: Bearer \[token\]"

*\# Bulk update camera analytics (LPR, etc)*  
*\# Example from EEPD-106093*  
curl "https://api.\[cluster\].eagleeyenetworks.com/api/v3.0/cameras/\[cameraId\]/analyticsSettings:bulkUpdate?include=newRegions" \\  
  \-X POST \\  
  \-H "accept: application/json" \\  
  \-H "Authorization: Bearer \[token\]" \\  
  \-d '\[analytics settings JSON\]'

*\# Get camera list with pagination*  
curl "https://api.\[cluster\].eagleeyenetworks.com/api/v3.0/cameras?pageToken=\&id\_\_in=\[cameraIds\]" \\  
  \-H "Authorization: Bearer \[token\]"

*\# Delete bridge/device (requires proper permissions)*  
*\# Example from EENS-133064*  
curl "https://\[domain\]/g/device?id=\[deviceId\]\&erase=1" \\  
  \-X DELETE \\  
  \-H "Authorization: Bearer \[token\]"

### Log Analysis & Monitoring

#### *VLogs (Application Logs)*

*\# General vlogs URL structure*  
https://vlogs.eencloud.com/select/vmui/\#/?query=\[query\]

*\# Search for specific container logs*  
*\# Example: VMS Core API logs for a specific camera (from EEPD-106093)*  
https://vlogs.eencloud.com/select/vmui/\#/?query=kubernetes.container\_name%3A"vms-core-api"\+AND+"\[cameraId\]"**&**g0.range\_input=15m

*\# Search for error messages*  
https://vlogs.eencloud.com/select/vmui/\#/?query=\_msg%3A"error"

*\# Search by cluster and specific keywords*  
https://vlogs.eencloud.com/select/vmui/\#/?query=**((**cluster%3A\+\[cluster\]**)**\+AND+\[keyword\]**)**

*\# Tips for vlogs:*  
*\# \- Use g0.range\_input for time range (e.g., 15m, 1h, 24h)*  
*\# \- Use g0.end\_input for specific end time*  
*\# \- Use displayFields to show specific log fields*

#### *Grafana Dashboards*

*\# NOC Dashboard for Reseller Rollup Refresh Lag*  
*\# Used to diagnose rollup timing issues (from EEPD-106192)*  
https://graphs.eencloud.com/d/ae6dc5zpyowe8a/noc3a-reseller-rollup-refresh-lag?orgId=1**&**refresh\=1h**&**from\=now-30m**&**to\=now

*\# General Grafana explore interface*  
https://graphs.eencloud.com/explore

*\# Check cluster health metrics*  
https://graphs.eencloud.com/d/\[dashboard-id\]

#### *Camera History Direct Links*

*\# Direct link to camera history at specific timestamp*  
*\# Format: https://\[cluster\].eagleeyenetworks.com/\#/camera\_history/\[cameraId\]/\[timestamp\]*  
*\# Example from EEPD-95638:*  
https://c006.eagleeyenetworks.com/\#/camera\_history/100b07c2/20241219023449.000

*\# Use this to share exact problematic timestamps with team*

### LPR-Specific Diagnostics

*\# Access camera LPR settings page*  
*\# Example from EEPD-105246:*  
http://\[cameraId\].a.plumv.com:28080/settings?id=\[cameraId\]

*\# Access LPR services diagnostic page*  
*\# Example from EEPD-104643:*  
http://\[bridgeId\].eagleeyenetworks.com:28080/lqservices.html

*\# Check if LPR events are being generated at camera level*  
*\# Check if events are reaching VSP*  
*\# Verify cloud LPR vs camera-direct LPR configuration*

### Admin Panel URLs

*\# EEN Admin \- Account Dashboard*  
https://eenadmin.eagleeyenetworks.com/eenadmin/account\_dashboard/\[accountId\]/

*\# Dealer/Reseller Portal \- Customer Details*  
https://dealer.cameramanager.com/\#/user/\[userId\]/\[customerId\]/\[customerId\]/customer-details

*\# Classic Interface \- Camera History*  
https://\[cluster\].eagleeyenetworks.com/\#/camera\_history/\[cameraId\]/\[timestamp\]

---

## Escalation Paths

### When to Escalate

1. **Multiple customers affected** \- Indicates potential platform issue

2. **Data loss risk** \- Footage missing or unrecoverable

3. **Security concerns** \- Unauthorized access or authentication issues

4. **Backend data corruption** \- Orphaned records, missing devices from API

5. **Unable to resolve with standard troubleshooting** \- After exhausting runbook steps

### Escalation Information to Collect

* Account ID (master and sub if applicable)

* Device ESN (camera, bridge)

* Support PIN

* User email

* Exact timestamp of issue (UTC)

* Cluster information

* Steps already taken

* Screenshots/logs

* Related Jira tickets

---

## Related Jira References

This runbook was built from analysis of these key tickets: \- EEPD-106192 (Offline rollup issues) \- EENS-133087 (Wrong footage status) \- EENS-133088 (Camera 404 errors) \- EENS-133007 (Bridge failures) \- EEPD-106093 (LPR disable issues) \- EEPD-105652 (Event subscription issues) \- EEPD-101298 (Playback buffering) \- EEPD-103382 (Preview freezing) \- And 43+ other resolved customer-impact tickets

---

## Quick Reference Checklist

### Initial Triage

* Verify customer account ID and contact info

* Confirm issue reproduction

* Check if issue is in Classic, Enhanced, or both

* Verify device ESN and cluster

* Check for similar recent tickets

* Review recent system changes/deployments

### Before Closing

* Document root cause

* Document resolution steps

* Update this runbook if new pattern discovered

* Verify customer confirmation

* Add knowledge base article if broadly applicable

---

**Note:** This is a living document. Update with new patterns as they emerge from customer-impact tickets.