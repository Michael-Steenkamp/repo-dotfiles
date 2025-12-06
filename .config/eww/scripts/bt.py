#!/usr/bin/env python3
import json
import subprocess
import sys


def run_command(cmd):
    # We pipe the command into bluetoothctl
    try:
        # 2>&1 redirects stderr to stdout so we capture everything
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
    devices = []
    # If no output or error, return empty
    if not raw_output:
        return []

    for line in raw_output.split("\n"):
        # Valid line: "Device 00:00:00:00:00:00 DeviceName"
        if "Device" not in line:
            continue

        parts = line.split()
        if len(parts) < 3:
            continue

        # [0]=Device, [1]=MAC, [2:]=Name
        mac = parts[1]
        name = " ".join(parts[2:])

        # Determine icon based on name
        icon = "󰂯"
        lower = name.lower()
        if any(
            x in lower
            for x in ["headphone", "headset", "bud", "pods", "xm4", "airpods"]
        ):
            icon = "󰋋"
        elif "phone" in lower:
            icon = ""
        elif "mouse" in lower:
            icon = "󰍽"
        elif "key" in lower:
            icon = "󰌌"
        elif "controller" in lower:
            icon = "󰊴"
        elif "tv" in lower:
            icon = ""

        devices.append({"mac": mac, "name": name, "icon": icon})
    return devices


def get_devices():
    # NEW COMMAND: 'devices Paired' instead of 'paired-devices'
    raw = run_command("devices Paired")
    parsed = parse_devices(raw)

    final_list = []
    for d in parsed:
        # Check connection status for each paired device
        # We can't use 'devices Connected' solely because we want to see DISCONNECTED paired devices too
        info = run_command(f"info {d['mac']}")
        connected = "Connected: yes" in info

        d["connected"] = connected
        d["status_text"] = "Connected" if connected else "Disconnected"
        d["color"] = "#a6e3a1" if connected else "#cdd6f4"
        d["action"] = "disconnect" if connected else "connect"

        final_list.append(d)

    print(json.dumps(final_list))


def get_status():
    # Fast check for JUST connected devices
    raw = run_command("devices Connected")
    parsed = parse_devices(raw)

    if parsed:
        print(parsed[0]["name"])  # Return the first connected device name
    else:
        print("Disconnected")


def connect_device(mac, action):
    # Send notification
    subprocess.Popen(
        f"notify-send 'Bluetooth' '{action.capitalize()}ing...'", shell=True
    )
    # Run connect/disconnect
    run_command(f"{action} {mac}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        exit(1)

    cmd = sys.argv[1]

    if cmd == "list":
        get_devices()
    elif cmd == "status":
        get_status()
    elif cmd == "connect":
        connect_device(sys.argv[2], sys.argv[3])
