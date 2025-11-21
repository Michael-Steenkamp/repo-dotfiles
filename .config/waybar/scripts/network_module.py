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

def get_network_data():
    env = os.environ.copy()
    env["LC_ALL"] = "C"
    try:
        cmd = ["nmcli", "-t", "-f", "ACTIVE,SSID,SIGNAL", "dev", "wifi"]
        result = subprocess.run(cmd, capture_output=True, text=True, env=env)
        if result.returncode == 0:
            for line in result.stdout.split('\n'):
                if line.startswith("yes") and len(line.split(':')) >= 3:
                    parts = line.split(':')
                    return ":".join(parts[1:-1]), int(parts[-1]), "wifi"

        cmd_eth = ["nmcli", "-t", "-f", "TYPE,STATE", "dev"]
        result_eth = subprocess.run(cmd_eth, capture_output=True, text=True, env=env)
        if result_eth.returncode == 0 and "ethernet:connected" in result_eth.stdout:
             return "Ethernet", 0, "ethernet"
    except:
        pass
    return None, 0, "disconnected"

def main():
    print(json.dumps({"text": "󰖪", "tooltip": "Initializing...", "class": "disconnected"}), flush=True)

    last_ssid = "INITIAL"
    last_change_time = 0

    while True:
        ssid, signal, net_type = get_network_data()
        current_time = time.time()

        if ssid != last_ssid:
            last_change_time = current_time
            last_ssid = ssid

        if net_type == "disconnected":
            text = "󰖪 "
            css_class = "disconnected"
            tooltip = "Disconnected"
        elif net_type == "ethernet":
            text = "󰈀 "
            css_class = "ethernet"
            tooltip = "Ethernet Connected"
        else:
            icon = " "
            time_diff = current_time - last_change_time

            if time_diff < DELAY_SECONDS:
                text = f"{icon} {signal}%"
                css_class = "expanded"
            elif time_diff < (DELAY_SECONDS + FADE_SECONDS):
                progress = (time_diff - DELAY_SECONDS) / FADE_SECONDS
                inverse = 1.0 - progress
                alpha = int(inverse * 65535)
                size_pct = int(inverse * 100)

                if size_pct > 10:
                    text = f"{icon} <span alpha='{alpha}' size='{size_pct}%'>{signal}%</span>"
                    css_class = "expanded"
                else:
                    text = icon
                    css_class = "minimized"
            else:
                text = icon
                css_class = "minimized"
            tooltip = f"Connected: {ssid} ({signal}%)"

        print(json.dumps({"text": text, "tooltip": tooltip, "class": css_class}), flush=True)
        time.sleep(POLL_TIME)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(0)
