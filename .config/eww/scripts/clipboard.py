#!/usr/bin/env python3
"""
clipboard.py
Interacts with `clipse` history.
Handles copying text OR binary image data to the clipboard.
Aggressively searches for image files in your specific clipse temp folder.
"""

import html
import json
import mimetypes
import os
import subprocess
import sys

HISTORY_FILE = os.path.expanduser("~/.config/clipse/clipboard_history.json")

# Define where your system saves the temporary images
CLIPSE_TMP_DIR = os.path.expanduser("~/.config/clipse/tmp_files")


def get_history():
    if not os.path.exists(HISTORY_FILE):
        print("[]")
        return

    try:
        with open(HISTORY_FILE, "r") as f:
            data = json.load(f)

        raw_list = data.get("clipboardHistory", [])
        output = []

        for idx, item in enumerate(raw_list):
            text = item.get("value", "")
            if not text:
                continue

            # Clean summary for sidebar
            summary = text.replace("\n", " ").replace("\t", " ")
            if len(summary) > 60:
                summary = summary[:60] + "..."

            output.append({"id": idx, "summary": html.escape(summary)})

        print(json.dumps(output))
    except Exception:
        print("[]")


def resolve_image_path(text):
    """
    Tries to find the actual image file from the clipboard text.
    Handles '📷 filename.png' format and checks your specific clipse folder.
    """
    # 1. Clean up the string (remove emoji, extra spaces)
    clean_path = text.replace("📷", "").strip()

    # 2. Define likely locations
    candidates = [
        os.path.join(CLIPSE_TMP_DIR, clean_path),  # <--- YOUR SPECIFIC PATH
        clean_path,  # Absolute path
        os.path.join("/tmp", clean_path),  # Standard temp fallback
        os.path.expanduser(f"~/.cache/clipse/{clean_path}"),  # Common cache fallback
    ]

    for path in candidates:
        if os.path.exists(path) and os.path.isfile(path):
            return path

    return None


def get_content(index):
    """Returns full content and detects type (text vs image) for the inspector popup."""
    try:
        with open(HISTORY_FILE, "r") as f:
            data = json.load(f)

        raw_list = data.get("clipboardHistory", [])
        if 0 <= index < len(raw_list):
            content = raw_list[index].get("value", "")

            # Try to resolve it as an image file
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
    """Copies item to clipboard. If it's an image file, copies the IMAGE DATA."""
    try:
        with open(HISTORY_FILE, "r") as f:
            data = json.load(f)

        raw_list = data.get("clipboardHistory", [])
        if 0 <= index < len(raw_list):
            content = raw_list[index].get("value", "")

            # 1. Try to find the image file
            img_path = resolve_image_path(content)

            if img_path:
                # IT IS AN IMAGE: Open file in binary mode and feed to wl-copy
                mime = mimetypes.guess_type(img_path)[0] or "image/png"
                try:
                    with open(img_path, "rb") as img_file:
                        subprocess.run(
                            ["wl-copy", "--type", mime], stdin=img_file, check=True
                        )
                    return
                except Exception:
                    pass

            # 2. FALLBACK: Treat as standard text
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
