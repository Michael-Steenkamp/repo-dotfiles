#!/usr/bin/env python3
"""
sys_info.py
Retrieves system metrics (CPU Temp, GPU Usage, Network Speed, RAM Hog) for Eww.
Includes recursive logic to trace 'isolated' processes back to their main parent application.
"""

import json
import os
import subprocess
import time

import psutil

CACHE_FILE = "/tmp/eww_net_state"


def get_net_speed():
    """Calculates upload/download speed based on a 2-second delta."""
    try:
        counters = psutil.net_io_counters()
        curr = {
            "recv": counters.bytes_recv,
            "sent": counters.bytes_sent,
            "time": time.time(),
        }

        down_speed = 0
        up_speed = 0

        if os.path.exists(CACHE_FILE):
            try:
                with open(CACHE_FILE, "r") as f:
                    prev = json.load(f)

                time_delta = curr["time"] - prev.get("time", 0)
                if time_delta > 0:
                    down_speed = (curr["recv"] - prev.get("recv", 0)) / time_delta
                    up_speed = (curr["sent"] - prev.get("sent", 0)) / time_delta
            except (json.JSONDecodeError, OSError):
                pass

        with open(CACHE_FILE, "w") as f:
            json.dump(curr, f)

        def fmt(speed):
            if speed > 1024 * 1024:
                return f"{speed / (1024 * 1024):.1f}M"
            elif speed > 1024:
                return f"{speed / 1024:.0f}K"
            return "0"

        return fmt(down_speed), fmt(up_speed)

    except Exception:
        return "0", "0"


def get_gpu():
    """Fetches GPU usage (Nvidia preferred, falls back to AMD)."""
    try:
        output = subprocess.check_output(
            [
                "nvidia-smi",
                "--query-gpu=utilization.gpu",
                "--format=csv,noheader,nounits",
            ],
            encoding="utf-8",
        )
        return int(output.strip())
    except (FileNotFoundError, subprocess.CalledProcessError):
        pass

    try:
        with open("/sys/class/drm/card0/device/gpu_busy_percent", "r") as f:
            return int(f.read().strip())
    except FileNotFoundError:
        pass

    return 0


def get_top_hog():
    """Identifies the process consuming the most RAM, recursively resolving parents."""
    try:
        # 1. Find the single heaviest process
        procs = list(psutil.process_iter(["name", "memory_percent", "pid", "ppid"]))
        if not procs:
            return "Unknown", 0

        # Sort by memory usage
        top = sorted(procs, key=lambda p: p.info["memory_percent"], reverse=True)[0]

        current_name = top.info["name"]
        mem_val = int(top.info["memory_percent"])
        current_pid = top.info["pid"]

        # List of generic names to ignore (Case insensitive matching)
        generic_terms = [
            "isolated",
            "web content",
            "web co",
            "privileged",
            "gpu-process",
            "extension",
            "utility",
            "rdd process",
            "socket process",
            "zygote",
            "renderer",
            "sandbox",
            "forkserver",
            "helper",
            "broker",
            "server",
        ]

        # 2. Walk up the tree if the name is generic
        # We limit the loop to 6 levels to prevent infinite loops
        depth = 0
        while depth < 6:
            # Check if current name matches any generic term
            lower_name = current_name.lower()
            if not any(term in lower_name for term in generic_terms):
                # Found a specific name! Stop here.
                break

            try:
                # Get the parent process object
                proc_obj = psutil.Process(current_pid)
                parent = proc_obj.parent()

                if not parent:
                    break  # No parent (reached root), stop.

                # Move up one level
                current_name = parent.name()
                current_pid = parent.pid
                depth += 1
            except (psutil.NoSuchProcess, psutil.AccessDenied):
                break

        return current_name, mem_val

    except Exception:
        return "Unknown", 0


def get_sys_info():
    """Main data aggregation."""
    temp = 0
    temp_dev = "System"
    sensor_map = {
        "coretemp": "CPU (Intel)",
        "k10temp": "CPU (AMD)",
        "amdgpu": "GPU",
        "acpitz": "ACPI",
    }

    try:
        temps = psutil.sensors_temperatures()
        for name, label in sensor_map.items():
            if name in temps:
                temp = temps[name][0].current
                temp_dev = label
                break
    except Exception:
        pass

    net_down, net_up = get_net_speed()
    hog_name, hog_val = get_top_hog()

    output = {
        "temp": int(temp),
        "temp_dev": temp_dev,
        "net_down": net_down,
        "net_up": net_up,
        "gpu": get_gpu(),
        "hog_name": hog_name[:8],
        "hog_full": hog_name,
        "hog_val": hog_val,
    }
    print(json.dumps(output))


if __name__ == "__main__":
    get_sys_info()
