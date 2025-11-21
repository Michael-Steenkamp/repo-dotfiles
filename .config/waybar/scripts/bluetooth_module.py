#!/usr/bin/env python3
import json
import os
import subprocess
import sys
import time

# CONFIGURATION
DELAY_SECONDS = 2.0
FADE_SECONDS  = 0.5
POLL_TIME     = 0.04

def get_bluetooth_data():
    env = os.environ.copy()
    env["LC_ALL"] = "C"
    try:
        show_out = subprocess.check_output(["bluetoothctl", "show"], stderr=subprocess.DEVNULL, env=env).decode("utf-8")
        if "Powered: no" in show_out: return 0, False

        dev_out = subprocess.check_output(["bluetoothctl", "devices", "Connected"], stderr=subprocess.DEVNULL, env=env).decode("utf-8")
        return len([line for line in dev_out.split('\n') if line.strip()]), True
    except:
        return 0, False

def main():
    print(json.dumps({"text": "", "tooltip": "Checking...", "class": "minimized"}), flush=True)

    last_count = -1
    last_change_time = 0

    while True:
        count, is_on = get_bluetooth_data()
        current_time = time.time()

        if count != last_count:
            last_change_time = current_time
            last_count = count

        if not is_on:
            text = "󰂲"
            css_class = "disabled"
        else:
            icon = ""
            if count > 0:
                time_diff = current_time - last_change_time

                if time_diff < DELAY_SECONDS:
                    text = f"{icon} {count}"
                    css_class = "expanded"
                elif time_diff < (DELAY_SECONDS + FADE_SECONDS):
                    progress = (time_diff - DELAY_SECONDS) / FADE_SECONDS
                    inverse = 1.0 - progress
                    alpha = int(inverse * 65535)
                    size_pct = int(inverse * 100)

                    if size_pct > 10:
                        text = f"{icon} <span alpha='{alpha}' size='{size_pct}%'>{count}</span>"
                        css_class = "expanded"
                    else:
                        text = icon
                        css_class = "minimized"
                else:
                    text = icon
                    css_class = "minimized"
            else:
                text = icon
                css_class = "minimized"

        print(json.dumps({"text": text, "tooltip": f"Connected: {count}", "class": css_class}), flush=True)
        time.sleep(POLL_TIME)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(0)
