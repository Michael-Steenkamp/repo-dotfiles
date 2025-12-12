#!/usr/bin/env python3
"""
audio.py
Manages Audio Devices (Sinks/Sources) and handles forcing stream migration
when switching devices in PipeWire/PulseAudio.
"""

import json
import subprocess
import sys


def run_cmd(args):
    """Helper to run shell commands and return stdout."""
    try:
        res = subprocess.run(args, capture_output=True, text=True)
        return res.stdout.strip()
    except Exception:
        return ""


def get_devices(kind):
    """Returns a JSON list of sinks or sources."""
    try:
        raw = run_cmd(["pactl", "-f", "json", "list", kind])
        devices = json.loads(raw)
        default_dev = run_cmd(["pactl", f"get-default-{kind[:-1]}"])

        output = []
        for d in devices:
            name = d.get("name", "")
            if kind == "sources" and "monitor" in name:
                continue

            output.append(
                {
                    "name": name,
                    "desc": d.get("description", "Unknown Device"),
                    "active": name == default_dev,
                }
            )

        output.sort(key=lambda x: x["active"], reverse=True)

        print(json.dumps(output))
    except Exception:
        print("[]")


def set_device(kind, name):
    """Sets default device and moves all active streams to it."""
    # kind: "sink" or "source"
    try:
        # 1. Set System Default
        subprocess.run(["pactl", f"set-default-{kind}", name])

        # 2. Move Active Streams
        # We must identify which streams are playing and force them to the new device.
        stream_type = "sink-inputs" if kind == "sink" else "source-outputs"
        move_cmd = "move-sink-input" if kind == "sink" else "move-source-output"

        # List streams: "ID  idx  client  proto  name"
        streams = run_cmd(["pactl", "list", "short", stream_type])

        for line in streams.splitlines():
            if not line:
                continue
            stream_id = line.split()[0]
            subprocess.run(["pactl", move_cmd, stream_id, name])

    except Exception:
        pass


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "sinks":
        get_devices("sinks")
    elif cmd == "sources":
        get_devices("sources")
    elif cmd == "set_sink":
        set_device("sink", sys.argv[2])
    elif cmd == "set_source":
        set_device("source", sys.argv[2])
