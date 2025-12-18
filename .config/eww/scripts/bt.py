#!/usr/bin/env python3
"""
bt.py
Manages Bluetooth devices using bluetoothctl.
Refactored to support 'listen' mode to prevent UI flickering.
"""

import json
import subprocess
import sys
import time


def run_bluetoothctl(cmd):
    """Pipes a command into bluetoothctl and returns output."""
    try:
        return (
            subprocess.check_output(
                f"echo '{cmd}' | bluetoothctl", shell=True, stderr=subprocess.STDOUT
            )
            .decode("utf-8")
            .strip()
        )
    except subprocess.CalledProcessError:
        return ""

def parse_devices(raw_output):
    """Parses bluetoothctl output into a list of dicts."""
    devices = []
    if not raw_output:
        return []

    for line in raw_output.split("\n"):
        if "Device" not in line:
            continue
        parts = line.split()
        if len(parts) < 3:
            continue

        mac = parts[1]
        name = " ".join(parts[2:])
        lower = name.lower()

        icon = "󰂯"
        if any(x in lower for x in ["headphone", "headset", "bud", "pods", "xm4", "airpods"]):
            icon = "󰋋"
        elif "phone" in lower:
            icon = ""
        elif "mouse" in lower:
            icon = "󰍽"
        elif "key" in lower:
            icon = "󰌌"
        elif "tv" in lower:
            icon = ""
        elif "controller" in lower:
            icon = "󰊴"

        devices.append({"mac": mac, "name": name, "icon": icon})
    return devices

def fetch_device_list():
    """Internal function to fetch and parse device list."""
    raw = run_bluetoothctl("devices Paired")
    parsed = parse_devices(raw)
    final_list = []

    for d in parsed:
        # Fetching info is 'expensive', so doing it inside the loop is why we need 'listen' mode
        info = run_bluetoothctl(f"info {d['mac']}")
        connected = "Connected: yes" in info

        d["connected"] = connected
        d["status_text"] = "Connected" if connected else "Disconnected"
        d["color"] = "#a6e3a1" if connected else "#cdd6f4"
        d["action"] = "disconnect" if connected else "connect"
        final_list.append(d)

    return final_list

def get_devices():
    """One-shot print."""
    print(json.dumps(fetch_device_list()))

def get_status():
    raw = run_bluetoothctl("devices Connected")
    parsed = parse_devices(raw)
    if parsed:
        print(parsed[0]["name"])
    else:
        print("Disconnected")

def connect_device(mac, action):
    try:
        subprocess.Popen(f"notify-send 'Bluetooth' '{action.capitalize()}ing...'", shell=True)
        run_bluetoothctl(f"{action} {mac}")
    except Exception:
        pass

def scan():
    try:
        subprocess.Popen(["timeout", "10s", "bluetoothctl", "scan", "on"])
    except Exception:
        pass

def listen():
    """Loops and only prints when data changes."""
    last_json = ""
    while True:
        data = fetch_device_list()
        current_json = json.dumps(data)

        if current_json != last_json:
            print(current_json, flush=True)
            last_json = current_json

        time.sleep(2)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "list":
        get_devices()
    elif cmd == "status":
        get_status()
    elif cmd == "scan":
        scan()
    elif cmd == "connect" and len(sys.argv) >= 4:
        connect_device(sys.argv[2], sys.argv[3])
    elif cmd == "listen":
        listen()
