#!/usr/bin/env python3
import json
import os
import subprocess
import sys


def print_status(title, artist, status):
    icon = "󰏤" if status == "Playing" else "󰐊"
    if not title:
        title = "No Music"
    if not artist:
        artist = ""

    # Print and FLUSH immediately
    print(
        json.dumps({"title": title, "artist": artist, "status": status, "icon": icon}),
        flush=True,
    )


def listen():
    # 1. Use stdbuf -oL to force playerctl to flush output line-by-line
    # 2. Monitor spotify_player first, fall back to others
    cmd = "stdbuf -oL playerctl -p spotify_player,spotify,%any metadata --format '{{title}}::{{artist}}::{{status}}' -F"

    # 3. Open subprocess (shell=True needed for stdbuf)
    process = subprocess.Popen(
        cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )

    while True:
        # 4. Read raw bytes line by line (bypassing Python's text buffer)
        line = process.stdout.readline()
        if not line:
            break

        try:
            decoded = line.decode("utf-8").strip()
            parts = decoded.split("::")

            if len(parts) >= 3:
                print_status(parts[0], parts[1], parts[2])
            else:
                # Fallback for weird output
                print_status("No Music", "", "Stopped")
        except Exception:
            continue


if __name__ == "__main__":
    try:
        listen()
    except KeyboardInterrupt:
        sys.exit(0)
