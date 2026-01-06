# Jaeger Trace Baseline Reference Guide

## Purpose
Document normal vs abnormal trace patterns for video playback troubleshooting.

---

## 1. Fast Cloud Read (HEALTHY)

### Pattern Indicators
- ✅ Uses `tf.reader.client` and `tf.reader.srv` spans
- ✅ Low duration (~150-500ms typical)
- ✅ Minimal span depth
- ✅ No upload or demand operations

### Example Trace
```
Trace ID: [FILL IN]
Camera ESN: [FILL IN]
Date/Time: [FILL IN]

Total Duration: 1.39s
Key Spans:
  - http get /asset/play/video.flv: 154.61ms
  - archiver tf.reader.client: 28.97ms
  - archiver tf.reader.srv: 28.79ms
  - archiver tf.reader.client: 104.67ms
  - archiver tf.reader.srv: 104.54ms

Total Spans: 26
Depth: 8
Services: 4
```

### When This Happens
- Video already in cloud storage
- Camera has proper cloud retention configured
- Historical footage (older than upload delay)

### User Experience
- Instant playback start
- No buffering
- Smooth seeking

---

## 2. Slow On-Demand Bridge Pull (PROBLEM)

### Pattern Indicators
- ❌ Uses `tf.demand.camera` spans (13+ seconds)
- ❌ Has `tf.upload` operations
- ❌ High span depth (14+ levels)
- ❌ Many spans (90+)

### Example Trace
```
Trace ID: [FILL IN]
Camera ESN: [FILL IN]
Date/Time: [FILL IN]

Total Duration: 15.42s
Key Spans:
  - http get /asset/play/video.flv: 11.22s
  - archiver tf.demand.camera: 13.4s
  - archiver tf.upload: 13.56s
  - archiver tf.demand.peer: 13.4s (if present)

Total Spans: 97
Depth: 14
Services: 4
```

### When This Happens (Potential Causes)
- Video not in cloud storage
- Cloud retention misconfigured
- Recent footage still uploading
- Storage quota issues
- Bridge upload bandwidth limited

### User Experience
- Delayed playback start (15+ seconds)
- Buffering during playback
- Slow seeking
- Possible timeouts

### Upload Speed Calculation
```
Video Duration: [X] seconds
Transfer Time: [Y] seconds
Upload Rate: X/Y = [Z]x real-time

Target: >5x real-time for good experience
Warning: <3x real-time will cause buffering
Critical: <2x real-time will timeout
```

---

## 3. Peer-to-Peer Archiver Transfer

### Pattern Indicators
- Uses `tf.demand.peer` spans
- Medium duration (faster than camera, slower than local read)
- Cross-region/cross-archiver transfers

### Example Trace
```
Trace ID: [FILL IN]
Camera ESN: [FILL IN]
Date/Time: [FILL IN]

Total Duration: [FILL IN]
Key Spans:
  - archiver tf.demand.peer: [FILL IN]
  - [OTHER KEY SPANS]

Total Spans: [FILL IN]
Depth: [FILL IN]
```

### When This Happens
- Video in different geographic archiver
- Multi-region deployment
- Load balancing across archivers

### User Experience
- Moderate delay (2-5 seconds typical)
- Generally acceptable performance

---

## 4. Failed/Error Traces

### Pattern Indicators
- Error tags on spans
- HTTP 4xx/5xx response codes
- Abnormally short or long durations
- Missing expected spans

### Example Trace
```
Trace ID: [FILL IN]
Camera ESN: [FILL IN]
Date/Time: [FILL IN]

Error Type: [e.g., 404 Not Found, 500 Internal Error, Timeout]
Failed Span: [Which operation failed]
Error Message: [From logs/tags]

Total Duration: [FILL IN]
```

### Common Error Patterns
- **404 Not Found**: Video doesn't exist for requested time range
- **401/403 Auth**: Permission issues, expired tokens
- **500 Internal Error**: Service crash, storage failure
- **Timeout**: Bridge unreachable, network issues

---

## 5. Request Type Comparison

### HLS Playlist (.m3u8)
```
Trace ID: [FILL IN]
Duration: [Typically <500ms - this is metadata only]
Purpose: Returns list of video segments
```

### HLS Segment (.m4s)
```
Trace ID: [FILL IN]
Duration: [Variable - actual video data]
Size: [bytes]
Video Duration: [seconds of video in segment]
```

### Thumbnail/Preview
```
Trace ID: [FILL IN]
Duration: [Typically <1s]
Purpose: Static image preview
```

---

## 6. Recent vs Historical Footage

### Very Recent (Last 5-10 minutes)
```
Trace ID: [FILL IN]
Camera ESN: [FILL IN]
Timestamp Requested: [FILL IN]

Pattern: May legitimately use tf.demand if not yet uploaded
Expected: tf.demand.camera acceptable for <10 min old footage
```

### Recent (1-24 hours)
```
Trace ID: [FILL IN]
Pattern: Should be in cloud storage by now
Expected: tf.reader pattern
```

### Historical (>24 hours)
```
Trace ID: [FILL IN]
Pattern: Must be in cloud storage
Expected: tf.reader pattern
If tf.demand: PROBLEM - investigate why not in cloud
```

---

## 7. Same Account Camera Comparison

### Camera A (Fast)
```
Camera ESN: [FILL IN]
Trace ID: [FILL IN]
Pattern: tf.reader
Duration: [FILL IN]
```

### Camera B (Slow)
```
Camera ESN: [FILL IN]
Trace ID: [FILL IN]
Pattern: tf.demand.camera
Duration: [FILL IN]
```

### Analysis
```
Same Account: [Yes/No]
Same Bridge: [Yes/No]
Same Retention Config: [Yes/No]

Hypothesis: [Why is Camera B slow but Camera A fast?]
```

---

## Performance Benchmarks

### Excellent (Cloud Read)
- Total Duration: 500ms - 2s
- Asset Request: <500ms
- Pattern: `tf.reader`
- User Experience: Instant playback

### Acceptable (Peer Transfer)
- Total Duration: 2s - 5s
- Asset Request: 1s - 3s
- Pattern: `tf.demand.peer`
- User Experience: Brief loading, smooth playback

### Poor (On-Demand Bridge)
- Total Duration: 5s - 15s
- Asset Request: 5s - 10s
- Pattern: `tf.demand.camera` with <5x real-time upload
- User Experience: Long loading, possible buffering

### Unacceptable (Timeout Risk)
- Total Duration: >15s
- Asset Request: >10s
- Pattern: `tf.demand.camera` with <2x real-time upload
- User Experience: Timeouts, constant buffering, unusable

---

## Investigation Checklist

When investigating slow traces:

- [ ] Check if video should be in cloud (>24 hours old)
- [ ] Verify cloud retention configuration for camera
- [ ] Check bridge storage capacity (orphaned data?)
- [ ] Verify bridge uplink bandwidth
- [ ] Check archiver storage availability
- [ ] Look for patterns across multiple cameras
- [ ] Compare with known-good camera on same account
- [ ] Check for related Jira tickets (retention bugs, etc.)
- [ ] Review recent configuration changes
- [ ] Check for network issues between bridge and archiver

---

## Span Dictionary

| Span Name | Meaning | Duration Indicator |
|-----------|---------|-------------------|
| `tf.reader.client` | Reading from cloud storage (client side) | <100ms = Good |
| `tf.reader.srv` | Reading from cloud storage (server side) | <100ms = Good |
| `tf.demand.camera` | On-demand pull from bridge/camera | >5s = Problem |
| `tf.demand.peer` | Transfer from peer archiver | 1-3s = Normal |
| `tf.upload` | Uploading to cloud storage | Long = Slow bridge uplink |
| `tf` | Generic TagFlow network operation | Varies |
| `asset.video` | Video asset processing | Varies |
| `hls-init-*` | HLS initialization | <100ms = Good |

---

## Notes & Observations

### [Date: YYYY-MM-DD]
```
Observation: [What you noticed]
Trace IDs: [Related traces]
Hypothesis: [What you think is happening]
Action Items: [What to investigate next]
```

### [Date: YYYY-MM-DD]
```
Observation:
Trace IDs:
Hypothesis:
Action Items:
```

---

## Related Documentation

- Jaeger Trace API: `/Users/adamgarcia/test-tools/qa-starter-kit/[path-to-trace-api-doc]`
- SWAT Ticket Guidelines: https://eagleeyenetworks.atlassian.net/wiki/spaces/ENG/pages/2691268878/
- Related Tickets:
  - EEPD-106946: CMVR retention deletion failure
  - [Add others as discovered]

---

## Quick Reference Commands

### Find trace by ID
```bash
# In Jaeger UI, search: <trace-id>
```

### Find traces by ESN
```bash
# In Jaeger UI:
# Service: media_v3_service
# Tags: camera_id=<esn>
```

### Extract trace ID from logs (Loki)
```
{kubernetes.pod_labels.app="media-service"} |= "100a6f6b" | json | line_format "{{.log.extra.trace_id}}"
```

### Check bridge for ESN config
```bash
grep -r "<esn>" /een/bridge/cameras/*/settings
ls -la /een/bridge/esns/ | grep <esn>
```

---

**Document Version:** 1.0
**Created:** 2026-01-05
**Last Updated:** 2026-01-05
**Maintainer:** Adam Garcia
