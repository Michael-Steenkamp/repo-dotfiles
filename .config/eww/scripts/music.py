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
# Ensure this is the correct path where spotify_player caches SavedTracks_cache
# If not, you can set using the -C flag (spotify_player -C <PATH>)
SPOTIFY_CACHE_PATH = "/home/user/.cache/spotify-player/SavedTracks_cache.json"


def isTrackLiked(title):
    """
    Checks if the given 'title' is present under the 'name' key in the
    spotify_player's liked tracks cache file.
    """
    # 1. Check if file exists
    if not os.path.exists("/home/user/.cache/spotify-player/SavedTracks_cache.json"):
        return "false"

    # 2. Read and parse the JSON file
    try:
        with open(SPOTIFY_CACHE_PATH, "r") as f:
            data = json.load(f)
    except json.JSONDecodeError:
        return "false"
    except Exception:
        return "false"

    # 3. Iterate through the dictionary values (the track objects)
    # The cache file is structured as: {"spotify:track:ID": {track_object}, ...}
    if isinstance(data, dict):
        for track_object in data.values():  # Iterate over values only
            if isinstance(track_object, dict):
                track_name = track_object.get("name")
                if track_name == title:
                    return "true"

    # 4. If the loop completes without finding a match
    return "false"


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

            is_liked = isTrackLiked(title)

            return {
                "title": title,
                "artist": artist,
                "status": status,
                "cover": final_cover,
                "liked": is_liked,
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
            "liked": data["liked"],
        }
    else:
        output = {
            "title": "No Music",
            "artist": "",
            "status": "Stopped",
            "cover": "",
            "liked": "",
        }

    print(json.dumps(output))


if __name__ == "__main__":
    main()
