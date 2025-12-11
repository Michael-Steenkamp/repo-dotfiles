#!/usr/bin/env python3
import json
import subprocess
import sys


def get_music_status():
    # Check spotify_player first, then spotify, then any other player
    # -s: silent (don't print errors if no player found)
    cmd = [
        "playerctl",
        "-p",
        "spotify_player,spotify,%any",
        "metadata",
        "--format",
        "{{title}}::{{artist}}::{{status}}",
        "-s",
    ]

    try:
        result = subprocess.run(cmd, capture_output=True, text=True)

        # If command failed or returned empty (no player found)
        if result.returncode != 0 or not result.stdout.strip():
            return None

        parts = result.stdout.strip().split("::")
        if len(parts) >= 3:
            return {"title": parts[0], "artist": parts[1], "status": parts[2]}
    except Exception:
        pass

    return None


def main():
    data = get_music_status()

    if data:
        title = data["title"] if data["title"] else "No Music"
        artist = data["artist"] if data["artist"] else ""
        status = data["status"]
        icon = "󰏤" if status == "Playing" else "󰐊"
    else:
        title = "No Music"
        artist = ""
        status = "Stopped"
        icon = "󰐊"

    # Create the final JSON object expected by Eww
    output = {"title": title, "artist": artist, "status": status, "icon": icon}

    print(json.dumps(output))


if __name__ == "__main__":
    main()
