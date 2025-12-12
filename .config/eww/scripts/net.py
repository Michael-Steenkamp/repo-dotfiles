#!/usr/bin/env python3
"""
net.py
Handles NetworkManager queries for Eww: SSID, Icon, and WiFi List.
"""

import json
import subprocess
import sys


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


def get_list():
    """Returns a JSON list of available WiFi networks."""
    # Format: SSID,SIGNAL,SECURITY
    raw = run_cmd("nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list")

    networks = []
    seen = set()

    for line in raw.split("\n"):
        if not line:
            continue

        # nmcli escapes colons in SSIDs with backslashes, but standard split is tricky.
        # We assume standard output: SSID:SIGNAL:SECURITY
        # A simple split usually works unless SSID contains ':'
        parts = line.split(":")

        # Basic validation
        if len(parts) < 2:
            continue

        # If SSID has colons, the length will be > 3.
        # The last two items are always Signal and Security.
        security = parts[-1]
        signal = parts[-2]
        ssid = ":".join(parts[:-2])

        if ssid and ssid not in seen:
            seen.add(ssid)
            networks.append(
                {"ssid": ssid, "signal": signal, "sec": "" if security else ""}
            )

    print(json.dumps(networks))


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
