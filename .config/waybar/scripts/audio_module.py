#!/usr/bin/env python3

import json
import subprocess
import sys
import time

# CONFIGURATION
DELAY_SECONDS = 1.0  # How long to show the number after changing volume


def get_volume_data():
    """Returns (volume_percentage, is_muted)"""
    try:
        # Get volume using pamixer
        vol = int(subprocess.check_output(["pamixer", "--get-volume"]).strip())
        muted = (
            subprocess.check_output(["pamixer", "--get-mute"]).strip().decode("utf-8")
            == "true"
        )
        return vol, muted
    except:
        return 0, True


def get_icon(vol, muted):
    """Determine which icon to show based on volume level"""
    if muted:
        return "󰝟"  # Muted icon
    if vol < 33:
        return ""  # Low volume
    elif vol < 66:
        return ""  # Mid volume
    else:
        return ""  # High volume


def main():
    last_vol = -1
    last_change_time = 0

    while True:
        current_vol, is_muted = get_volume_data()
        current_time = time.time()

        # Check if volume changed
        if current_vol != last_vol:
            last_change_time = current_time
            last_vol = current_vol

        # Determine what text to display
        icon = get_icon(current_vol, is_muted)

        # If specific time hasn't passed since last change, show percentage
        if (current_time - last_change_time) < DELAY_SECONDS:
            text = f"{icon} {current_vol}%"
            css_class = "expanded"
        else:
            # Otherwise, just show the icon (minimized)
            text = f"{icon}"
            css_class = "minimized"

        # Output JSON for Waybar
        output = {
            "text": text,
            "tooltip": f"Volume: {current_vol}%",
            "class": css_class,
            "percentage": current_vol,
        }

        print(json.dumps(output), flush=True)
        time.sleep(0.1)  # Check every 100ms


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(0)
