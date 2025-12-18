#!/usr/bin/env python3
import json
import os
import shutil
import subprocess
import urllib.parse
import urllib.request

# Files
COVER_PATH = "/tmp/eww_cover.png"
CACHE_ID_FILE = "/tmp/eww_cover_url.txt"
SPOTIFY_CACHE_PATH = os.path.expanduser("~/.cache/spotify-player/SavedTracks_cache.json")

def isTrackLiked(title):
    if not os.path.exists(SPOTIFY_CACHE_PATH):
        return "false"
    try:
        with open(SPOTIFY_CACHE_PATH, "r") as f:
            data = json.load(f)
        if isinstance(data, dict):
            for track_object in data.values():
                if isinstance(track_object, dict) and track_object.get("name") == title:
                    return "true"
    except Exception:
        pass
    return "false"

def get_music_status():
    cmd = [
        "playerctl", "-p", "spotify_player,spotify,%any", "metadata",
        "--format", "{{title}}::{{artist}}::{{status}}::{{mpris:artUrl}}", "-s",
    ]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0 or not result.stdout.strip():
            return None

        parts = result.stdout.strip().split("::")
        if len(parts) >= 3:
            title, artist, status = parts[0], parts[1], parts[2]
            art_url = parts[3] if len(parts) > 3 else ""
            final_cover = ""

            # --- SMART CACHING START ---
            # Check if we already have this art downloaded
            last_url = ""
            if os.path.exists(CACHE_ID_FILE):
                with open(CACHE_ID_FILE, "r") as f:
                    last_url = f.read().strip()

            if art_url:
                if art_url.startswith("file://"):
                    # Local file: just decode path
                    path = urllib.parse.unquote(art_url[7:])
                    final_cover = path
                elif art_url.startswith("http"):
                    # Web URL: Only download if it CHANGED
                    final_cover = COVER_PATH
                    if art_url != last_url or not os.path.exists(COVER_PATH):
                        try:
                            # 1. Download to a temp file first (Atomic Write Safety)
                            temp_dl = COVER_PATH + ".tmp"
                            urllib.request.urlretrieve(art_url, temp_dl)

                            # 2. Move it to the real path (Atomic Move)
                            # This prevents Eww from reading a half-written file
                            shutil.move(temp_dl, COVER_PATH)

                            # 3. Update the cache ID
                            with open(CACHE_ID_FILE, "w") as f:
                                f.write(art_url)
                        except Exception:
                            pass
            # --- SMART CACHING END ---

            # Escape quotes for CSS
            if final_cover:
                final_cover = final_cover.replace("'", "\\'")

            return {
                "title": title, "artist": artist, "status": status,
                "cover": final_cover, "liked": isTrackLiked(title),
            }
    except Exception:
        pass
    return None

def main():
    data = get_music_status()
    if data:
        output = data
    else:
        # Default state
        output = {"title": "No Music", "artist": "", "status": "Stopped", "cover": "", "liked": ""}

    print(json.dumps(output))

if __name__ == "__main__":
    main()
