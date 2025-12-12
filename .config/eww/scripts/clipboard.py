#!/usr/bin/env python3

import html
import json
import os
import subprocess
import sys

# Adjust this path if your config is different
HISTORY_FILE = os.path.expanduser("~/.config/clipse/clipboard_history.json")


def get_history():
    if not os.path.exists(HISTORY_FILE):
        print("[]")
        return

    try:
        with open(HISTORY_FILE, "r") as f:
            data = json.load(f)

        # Clipse stores items in 'clipboardHistory'
        raw_list = data.get("clipboardHistory", [])

        output = []
        # enumerate gives us an index (0, 1, 2...) to use as an ID
        for idx, item in enumerate(raw_list):
            text = item.get("value", "")
            if not text:
                continue

            # Create a clean summary for display (first 50 chars, no newlines)
            summary = text.replace("\n", " ").replace("\t", " ")
            if len(summary) > 100:
                summary = summary[:100] + "..."

            output.append(
                {
                    "id": idx,
                    "summary": html.escape(summary),  # Escape < > & for Pango markup
                }
            )

        print(json.dumps(output))
    except Exception as e:
        print("[]")


def copy_item(index):
    try:
        with open(HISTORY_FILE, "r") as f:
            data = json.load(f)

        raw_list = data.get("clipboardHistory", [])
        if 0 <= index < len(raw_list):
            content = raw_list[index].get("value", "")

            # Use wl-copy to set clipboard
            subprocess.run(["wl-copy"], input=content.encode("utf-8"))
    except Exception:
        pass


def clear_history():
    try:
        # Write empty list to file
        with open(HISTORY_FILE, "w") as f:
            json.dump({"clipboardHistory": []}, f)
    except Exception:
        pass


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)

    command = sys.argv[1]

    if command == "list":
        get_history()
    elif command == "copy":
        copy_item(int(sys.argv[2]))
    elif command == "clear":
        clear_history()
