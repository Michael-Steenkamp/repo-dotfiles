#!/usr/bin/env python3
"""
net.py
Handles NetworkManager queries for Eww: SSID, Icon, and WiFi List.
Refactored to support 'listen' mode to prevent UI flickering.
"""

import json
import subprocess
import sys
import time


def run_cmd(cmd):
    """Runs a shell command and returns stripped stdout."""
    try:
        return subprocess.run(
            cmd, shell=True, capture_output=True, text=True
        ).stdout.strip()
    except Exception:
        return ""

def get_ssid():
    """Returns the current active SSID or 'Disconnected'."""
    cmd = "nmcli -t -f active,ssid dev wifi | awk -F: '$1==\"yes\"{print $2}'"
    ssid = run_cmd(cmd)
    print(ssid if ssid else "Disconnected")

def get_icon():
    """Returns a WiFi icon based on connection state."""
    state = run_cmd("nmcli -t -f STATE general")
    print("󰤨" if state == "connected" else "󰤭")

def scan():
    """Triggers a WiFi rescan in the background."""
    try:
        subprocess.Popen(["nmcli", "device", "wifi", "rescan"])
    except Exception:
        pass

def fetch_wifi_list():
    """Internal function to fetch and parse the wifi list."""
    raw = run_cmd("nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list")

    networks = []
    seen = set()

    for line in raw.split("\n"):
        if not line:
            continue

        parts = line.split(":")
        if len(parts) < 3:
            continue

        in_use = parts[0]
        security = parts[-1]
        signal = parts[-2]
        ssid = ":".join(parts[1:-2])

        if ssid and ssid not in seen:
            seen.add(ssid)
            is_active = in_use == "*"
            networks.append(
                {
                    "ssid": ssid,
                    "signal": signal,
                    "sec": "" if security else "",
                    "active": is_active,
                }
            )

    networks.sort(
        key=lambda x: (
            not x["active"],
            -int(x["signal"]) if x["signal"].isdigit() else 0,
        )
    )
    return networks

def get_list():
    """One-shot print for debugging or legacy poll."""
    print(json.dumps(fetch_wifi_list()))

def listen():
    """Loops and only prints when data changes (Anti-Flicker)."""
    last_json = ""
    while True:
        data = fetch_wifi_list()
        current_json = json.dumps(data)

        if current_json != last_json:
            print(current_json, flush=True)
            last_json = current_json

        # Poll every 2 seconds. Since we only print on change,
        # Eww won't redraw/flicker if the data is stable.
        time.sleep(2)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "ssid":
        get_ssid()
    elif cmd == "icon":
        get_icon()
    elif cmd == "scan":
        scan()
    elif cmd == "list":
        get_list()
    elif cmd == "listen":
        listen()
