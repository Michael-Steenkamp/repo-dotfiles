#!/usr/bin/env python3
import json
import subprocess
import sys


def get_devices(kind):
    # kind is "sinks" (outputs) or "sources" (inputs)
    try:
        # Get JSON list of devices
        cmd = ["pactl", "-f", "json", "list", kind]
        res = subprocess.run(cmd, capture_output=True, text=True)
        devices = json.loads(res.stdout)

        # Get the name of the currently default device
        default_cmd = ["pactl", f"get-default-{kind[:-1]}"]
        default_dev = subprocess.run(
            default_cmd, capture_output=True, text=True
        ).stdout.strip()

        output = []
        for d in devices:
            # Filter out "Monitor" sources (which are just recording desktop audio)
            if kind == "sources" and "monitor" in d.get("name", ""):
                continue

            output.append(
                {
                    "name": d.get("name"),
                    "desc": d.get("description", "Unknown Device"),
                    "active": d.get("name") == default_dev,
                }
            )

        print(json.dumps(output))
    except Exception:
        print("[]")


def set_device(kind, name):
    try:
        # 1. Set the default device (for future apps)
        subprocess.run(["pactl", f"set-default-{kind}", name])

        # 2. Move ALL currently playing streams to the new device
        if kind == "sink":
            # List all playing streams (sink-inputs)
            # Output format: "ID  sink_idx  client_idx  proto  name"
            res = subprocess.run(
                ["pactl", "list", "short", "sink-inputs"],
                capture_output=True,
                text=True,
            )
            for line in res.stdout.splitlines():
                if not line:
                    continue
                # The first column is the Stream ID
                stream_id = line.split()[0]
                # Force move this stream to the new sink
                subprocess.run(["pactl", "move-sink-input", stream_id, name])

        elif kind == "source":
            # List all recording streams (source-outputs)
            res = subprocess.run(
                ["pactl", "list", "short", "source-outputs"],
                capture_output=True,
                text=True,
            )
            for line in res.stdout.splitlines():
                if not line:
                    continue
                stream_id = line.split()[0]
                subprocess.run(["pactl", "move-source-output", stream_id, name])

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
