"""Ticket theme classification by summary keyword matching."""

THEMES = [
    ("PTZ",                   ["ptz"]),
    ("Audio",                 ["audio"]),
    ("Cluster / Archiver",    ["cluster", "archiver"]),
    ("Playback / History",    ["playback", "history browser", "hb ", "hb-", "timeline", "footage"]),
    ("Camera Offline",        ["offline", "falling offline"]),
    ("Streaming",             ["stream", "live view", "live feed"]),
    ("Detection / CV",        ["detection", "person and vehicle", "vehicle detection", "analytics"]),
    ("Download / Retention",  ["download", "retention", "purge"]),
    ("Notifications",         ["notification", "alert", "email"]),
    ("Bridge / Cabinet",      ["bridge", "cabinet", "br820", "br3"]),
    ("Access / Permissions",  ["access", "permission", "layout", "grant"]),
    ("Mobile",                ["mobile"]),
    ("Vulnerabilities",       ["vulnerabilit", "security"]),
    ("Enhanced UI",           ["enhanced", "classic", "webappv1"]),
]


def classify_theme(summary):
    s = summary.lower()
    for label, keywords in THEMES:
        if any(kw in s for kw in keywords):
            return label
    return "Other"
