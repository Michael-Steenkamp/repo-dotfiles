#!/usr/bin/env python3
"""
clipboard.py
Interacts with `clipse` history.
Optimized to process only the most recent 50 items to prevent UI lag.
"""

import html
import json
import mimetypes
import os
import subprocess
import sys

HISTORY_FILE = os.path.expanduser("~/.config/clipse/clipboard_history.json")
CLIPSE_TMP_DIR = os.path.expanduser("~/.config/clipse/tmp_files")


def get_history():
    if not os.path.exists(HISTORY_FILE):
        print("[]", flush=True)
        return

    try:
        with open(HISTORY_FILE, "r") as f:
            data = json.load(f)

        raw_list = data.get("clipboardHistory", [])
        output = []

        # OPTIMIZATION: Slice the list first!
        # Only process the first 50 items. No need to render 1000 items in Eww.
        for idx, item in enumerate(raw_list[:50]):
            text = item.get("value", "")
            if not text:
                continue

            # Clean summary for sidebar
            summary = text.replace("\n", " ").replace("\t", " ")
            if len(summary) > 60:
                summary = summary[:60] + "..."

            output.append({"id": idx, "summary": html.escape(summary)})

        print(json.dumps(output), flush=True)

    except Exception:
        print("[]", flush=True)


def resolve_image_path(text):
    """
    Tries to find the actual image file from the clipboard text.
    """
    clean_path = text.replace("📷", "").strip()

    candidates = [
        os.path.join(CLIPSE_TMP_DIR, clean_path),
        clean_path,
        os.path.join("/tmp", clean_path),
        os.path.expanduser(f"~/.cache/clipse/{clean_path}"),
    ]

    for path in candidates:
        if os.path.exists(path) and os.path.isfile(path):
            return path

    return None


def get_content(index):
    """Returns full content for the inspector popup."""
    try:
        with open(HISTORY_FILE, "r") as f:
            data = json.load(f)

        raw_list = data.get("clipboardHistory", [])
        if 0 <= index < len(raw_list):
            content = raw_list[index].get("value", "")
            img_path = resolve_image_path(content)

            if img_path:
                result = {"type": "image", "content": img_path}
            else:
                result = {"type": "text", "content": content}

            print(json.dumps(result))
            return

    except Exception:
        pass

    print(json.dumps({"type": "text", "content": "Error reading item"}))


def copy_item(index):
    """Copies item to clipboard."""
    try:
        with open(HISTORY_FILE, "r") as f:
            data = json.load(f)

        raw_list = data.get("clipboardHistory", [])
        if 0 <= index < len(raw_list):
            content = raw_list[index].get("value", "")
            img_path = resolve_image_path(content)

            if img_path:
                mime = mimetypes.guess_type(img_path)[0] or "image/png"
                try:
                    with open(img_path, "rb") as img_file:
                        subprocess.run(
                            ["wl-copy", "--type", mime], stdin=img_file, check=True
                        )
                    return
                except Exception:
                    pass

            subprocess.run(["wl-copy"], input=content.encode("utf-8"), check=True)
    except Exception:
        pass


def clear_history():
    try:
        with open(HISTORY_FILE, "w") as f:
            json.dump({"clipboardHistory": []}, f)
    except Exception:
        pass


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "list":
        get_history()
    elif cmd == "copy":
        copy_item(int(sys.argv[2]))
    elif cmd == "clear":
        clear_history()
    elif cmd == "inspect":
        get_content(int(sys.argv[2]))
