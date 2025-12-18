#!/usr/bin/env python3
import json
import os
import shutil
import subprocess
import sys
import time
import urllib.parse
import urllib.request

# --- CONFIG ---
COVER_PATH = "/tmp/eww_cover.png"
CACHE_ID_FILE = "/tmp/eww_cover_url.txt"
SPOTIFY_CACHE = os.path.expanduser("~/.cache/spotify-player/SavedTracks_cache.json")

def get_player_meta():
    """Runs playerctl and returns raw strings for title, artist, status, url."""
    cmd = [
        "playerctl", "-p", "spotify_player,spotify,%any", "metadata",
        "--format", "{{title}}::{{artist}}::{{status}}::{{mpris:artUrl}}", "-s"
    ]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip().split("::")
    except Exception:
        pass
    return None

def is_track_liked(title):
    if not os.path.exists(SPOTIFY_CACHE):
        return "false"
    try:
        with open(SPOTIFY_CACHE, "r") as f:
            if title in f.read(): # Quick check to avoid heavy JSON parsing every second
                return "true"
    except Exception:
        pass
    return "false"

def ensure_cover_image(art_url):
    """Downloads cover art ONLY if the URL is new."""
    if not art_url:
        return ""

    # 1. Check Cache
    last_url = ""
    if os.path.exists(CACHE_ID_FILE):
        with open(CACHE_ID_FILE, "r") as f:
            last_url = f.read().strip()

    # 2. If URL is different, download/update
    if art_url != last_url or not os.path.exists(COVER_PATH):
        if art_url.startswith("file://"):
            # Local file: Return path directly, no copy needed
            return urllib.parse.unquote(art_url[7:])
        elif art_url.startswith("http"):
            try:
                temp_dl = COVER_PATH + ".tmp"
                urllib.request.urlretrieve(art_url, temp_dl)
                shutil.move(temp_dl, COVER_PATH) # Atomic move
                with open(CACHE_ID_FILE, "w") as f:
                    f.write(art_url)
            except Exception:
                return ""

    return COVER_PATH

def main():
    last_json_str = ""

    while True:
        parts = get_player_meta()

        if parts and len(parts) >= 3:
            title, artist, status = parts[0], parts[1], parts[2]
            raw_url = parts[3] if len(parts) > 3 else ""

            # Smart Cache the Image
            cover_path = ensure_cover_image(raw_url)

            # Escape for CSS
            if cover_path:
                cover_path = cover_path.replace("'", "\\'")

            data = {
                "title": title,
                "artist": artist,
                "status": status,
                "cover": cover_path,
                "liked": is_track_liked(title)
            }
        else:
            data = {
                "title": "No Music",
                "artist": "",
                "status": "Stopped",
                "cover": "",
                "liked": "false"
            }

        # --- CRITICAL OPTIMIZATION ---
        # Convert to string and compare with the last printed line.
        # If it's the same, WE DO NOT PRINT. Eww stays silent.
        # GTK does not redraw. No flickering.
        current_json_str = json.dumps(data)

        if current_json_str != last_json_str:
            print(current_json_str, flush=True)
            last_json_str = current_json_str

        time.sleep(1)

if __name__ == "__main__":
    main()
