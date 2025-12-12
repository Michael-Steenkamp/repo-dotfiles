#!/usr/bin/env python3
"""
music.py
Fetches metadata from playerctl and downloads album art.
"""

import json
import os
import subprocess
import urllib.request

COVER_PATH = "/tmp/eww_cover.png"
DEFAULT_COVER = ""


def get_music_status():
    # Command to fetch: Title, Artist, Status, ArtUrl
    cmd = [
        "playerctl",
        "-p",
        "spotify_player,spotify,%any",
        "metadata",
        "--format",
        "{{title}}::{{artist}}::{{status}}::{{mpris:artUrl}}",
        "-s",
    ]

    try:
        result = subprocess.run(cmd, capture_output=True, text=True)

        if result.returncode != 0 or not result.stdout.strip():
            return None

        parts = result.stdout.strip().split("::")
        if len(parts) >= 3:
            title = parts[0]
            artist = parts[1]
            status = parts[2]
            art_url = parts[3] if len(parts) > 3 else ""

            final_cover = DEFAULT_COVER

            if art_url:
                # Case 1: Local File
                if art_url.startswith("file://"):
                    final_cover = art_url[7:]

                # Case 2: Web URL (Spotify/SoundCloud)
                elif art_url.startswith("http"):
                    try:
                        # Download with a 2-second timeout to prevent lag
                        urllib.request.urlretrieve(art_url, COVER_PATH)
                        final_cover = COVER_PATH
                    except Exception:
                        pass

            return {
                "title": title,
                "artist": artist,
                "status": status,
                "cover": final_cover,
            }

    except Exception:
        pass

    return None


def main():
    data = get_music_status()

    if data:
        output = {
            "title": data["title"] or "No Music",
            "artist": data["artist"] or "",
            "status": data["status"],
            "cover": data["cover"],
        }
    else:
        output = {"title": "No Music", "artist": "", "status": "Stopped", "cover": ""}

    print(json.dumps(output))


if __name__ == "__main__":
    main()
