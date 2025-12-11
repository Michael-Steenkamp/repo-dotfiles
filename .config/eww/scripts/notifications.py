#!/usr/bin/env python3

import json
import re
import subprocess
import sys


# Clean text function
def clean_text(text):
    if not text:
        return ""
    return re.sub(r"<[^>]*>", "", text).strip()


def get_history():
    try:
        # Fetch history from dunst
        result = subprocess.run(["dunstctl", "history"], capture_output=True, text=True)
        data = json.loads(result.stdout)

        # Dunst returns {'data': [[ ... ]]}
        history = data.get("data", [[]])[0]

        processed = []
        # Limit to 20 items
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


if __name__ == "__main__":
    get_history()
