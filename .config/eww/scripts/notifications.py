#!/usr/bin/env python3
"""
notifications.py
Fetches history from dunstctl and handles deletion.
"""

import json
import re
import subprocess
import sys


def clean_text(text):
    if not text:
        return ""
    # Remove HTML tags
    text = re.sub(r"<[^>]*>", "", text).strip()
    # CRITICAL: Replace single quotes with backticks or typographic quotes
    # to prevent breaking Eww's 'onclick' command string.
    return text.replace("'", "’").replace('"', "”")


def get_history():
    try:
        result = subprocess.run(["dunstctl", "history"], capture_output=True, text=True)
        data = json.loads(result.stdout)
        history = data.get("data", [[]])[0]

        processed = []
        for notif in history[:20]:
            app = notif.get("appname", {}).get("data", "System")
            summary = clean_text(notif.get("summary", {}).get("data", ""))
            body = clean_text(notif.get("body", {}).get("data", ""))
            urgency = notif.get("urgency", {}).get("data", 1)
            id_val = notif.get("id", {}).get("data", 0)

            processed.append(
                {
                    "id": id_val,
                    "app": app,
                    "summary": summary,
                    "body": body,
                    "urgency": urgency,
                }
            )
        print(json.dumps(processed))
    except Exception:
        print("[]")


def delete_notif(notif_id):
    try:
        # Remove specific notification from history
        subprocess.run(["dunstctl", "history-rm", str(notif_id)])
    except Exception:
        pass


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "list"

    if cmd == "list":
        get_history()
    elif cmd == "delete" and len(sys.argv) > 2:
        delete_notif(sys.argv[2])
