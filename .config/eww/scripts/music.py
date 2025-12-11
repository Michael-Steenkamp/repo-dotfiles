#!/usr/bin/env python3
import json
import os
import subprocess
import urllib.request

# Path where we save the album art
COVER_PATH = "/tmp/eww_cover.png"
# Placeholder image if no art is found (empty transparent or a default icon)
DEFAULT_COVER = ""


def get_music_status():
    # Fetch Title, Artist, Status, and Art URL
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

            # --- Image Handling ---
            final_cover = DEFAULT_COVER

            if art_url:
                # If it's a local file (mpd/local files), strip 'file://'
                if art_url.startswith("file://"):
                    final_cover = art_url[7:]
                # If it's a web URL (Spotify), download it
                elif art_url.startswith("http"):
                    # Optimization: Only download if the URL changed?
                    # For simplicity in this script, we just download.
                    # (In a perfect world, we'd cache this based on song ID)
                    try:
                        urllib.request.urlretrieve(art_url, COVER_PATH)
                        final_cover = COVER_PATH
                    except:
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
        title = data["title"] if data["title"] else "No Music"
        artist = data["artist"] if data["artist"] else ""
        status = data["status"]
        cover = data["cover"]
    else:
        title = "No Music"
        artist = ""
        status = "Stopped"
        cover = ""

    # Generate JSON
    output = {"title": title, "artist": artist, "status": status, "cover": cover}

    print(json.dumps(output))


if __name__ == "__main__":
    main()
