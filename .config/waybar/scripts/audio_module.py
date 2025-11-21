#!/usr/bin/env python3
import json
import os
import subprocess
import sys
import time

# CONFIGURATION
DELAY_SECONDS = 2.0    # Time to stay fully visible
FADE_SECONDS  = 0.4    # Faster fade for a snappier feel
POLL_TIME     = 0.04   # High refresh rate for smooth sliding

def get_volume_data():
    env = os.environ.copy()
    env["LC_ALL"] = "C"
    try:
        vol = int(subprocess.check_output(["pamixer", "--get-volume"], stderr=subprocess.DEVNULL, env=env).strip())
        muted = subprocess.check_output(["pamixer", "--get-mute"], stderr=subprocess.DEVNULL, env=env).strip().decode("utf-8") == "true"
        return vol, muted
    except:
        return 0, True

def get_icon(vol, muted):
    if muted: return "󰝟"
    if vol < 33: return ""
    elif vol < 66: return ""
    else: return ""

def main():
    print(json.dumps({"text": "", "tooltip": "Loading...", "class": "minimized"}), flush=True)

    last_vol = -1
    last_change_time = 0

    while True:
        current_vol, is_muted = get_volume_data()
        current_time = time.time()

        if current_vol != last_vol:
            last_change_time = current_time
            last_vol = current_vol

        icon = get_icon(current_vol, is_muted)
        time_diff = current_time - last_change_time

        if time_diff < DELAY_SECONDS:
            # Phase 1: Fully Visible
            text = f"{icon} {current_vol}%"
            css_class = "expanded"

        elif time_diff < (DELAY_SECONDS + FADE_SECONDS):
            # Phase 2: Shrink & Fade
            # Calculate progress 0.0 -> 1.0
            progress = (time_diff - DELAY_SECONDS) / FADE_SECONDS
            inverse = 1.0 - progress

            # Alpha: 65535 is 100% opacity
            alpha = int(inverse * 65535)

            # Size: 100% (10000) down to 1% (100)
            # We use Pango 'pct' for relative sizing
            size_pct = int(inverse * 100)

            # Apply to the NUMBER only, keep icon steady
            if size_pct > 10:
                text = f"{icon} <span alpha='{alpha}' size='{size_pct}%'>{current_vol}%</span>"
                css_class = "expanded"
            else:
                # If too small, just snap to minimized to avoid glitches
                text = icon
                css_class = "minimized"

        else:
            # Phase 3: Hidden
            text = f"{icon}"
            css_class = "minimized"

        output = {
            "text": text,
            "tooltip": f"Volume: {current_vol}%",
            "class": css_class
        }

        print(json.dumps(output), flush=True)
        time.sleep(POLL_TIME)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(0)
