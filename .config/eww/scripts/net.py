#!/usr/bin/env python3
import json
import subprocess
import sys


def run(cmd):
    return subprocess.run(
        cmd, shell=True, capture_output=True, text=True
    ).stdout.strip()


def get_ssid():
    ssid = run("nmcli -t -f active,ssid dev wifi | awk -F: '$1==\"yes\"{print $2}'")
    print(ssid if ssid else "Disconnected")


def get_icon():
    state = run("nmcli -t -f STATE general")
    print("󰤨" if state == "connected" else "󰤭")


def scan():
    # Runs a rescan in the background
    subprocess.Popen(["nmcli", "device", "wifi", "rescan"])


def get_list():
    # Get raw list: SSID, Signal, Security
    raw = run("nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list")
    networks = []
    seen = set()

    for line in raw.split("\n"):
        if not line:
            continue
        # nmcli -t uses ':' as separator, but SSIDs can have colons.
        # Ideally we limit the split, but SSID is first, so we are careful.
        parts = line.split(":")
        if len(parts) < 2:
            continue

        ssid = parts[0]
        signal = parts[1]
        security = parts[2] if len(parts) > 2 else ""

        if ssid and ssid not in seen:
            seen.add(ssid)
            networks.append(
                {"ssid": ssid, "signal": signal, "sec": "" if security else ""}
            )

    print(json.dumps(networks))


if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "ssid":
        get_ssid()
    elif cmd == "icon":
        get_icon()
    elif cmd == "toggle":
        toggle()
    elif cmd == "scan":
        scan()
    elif cmd == "list":
        get_list()
