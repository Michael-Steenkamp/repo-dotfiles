#!/usr/bin/env python3
import json
import os
import subprocess
import time

import psutil

# File to store previous network stats
CACHE_FILE = "/tmp/eww_net_state"


def get_net_speed():
    try:
        counters = psutil.net_io_counters()
        curr_bytes_recv = counters.bytes_recv
        curr_bytes_sent = counters.bytes_sent
        curr_time = time.time()

        down_speed = 0
        up_speed = 0

        if os.path.exists(CACHE_FILE):
            with open(CACHE_FILE, "r") as f:
                try:
                    data = json.load(f)
                    prev_recv = data.get("recv", 0)
                    prev_sent = data.get("sent", 0)
                    prev_time = data.get("time", 0)

                    time_delta = curr_time - prev_time
                    if time_delta > 0:
                        down_speed = (curr_bytes_recv - prev_recv) / time_delta
                        up_speed = (curr_bytes_sent - prev_sent) / time_delta
                except:
                    pass

        with open(CACHE_FILE, "w") as f:
            json.dump(
                {"recv": curr_bytes_recv, "sent": curr_bytes_sent, "time": curr_time}, f
            )

        def fmt(speed):
            if speed > 1024 * 1024:
                return f"{speed / (1024 * 1024):.1f}M"
            elif speed > 1024:
                return f"{speed / 1024:.0f}K"
            return "0"

        # Return BOTH speeds now
        return f"{fmt(down_speed)}", f"{fmt(up_speed)}"
    except:
        return "0", "0"


def get_gpu():
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
    except:
        pass
    try:
        with open("/sys/class/drm/card0/device/gpu_busy_percent", "r") as f:
            return int(f.read().strip())
    except:
        return 0


def get_top_hog():
    try:
        procs = list(psutil.process_iter(["name", "memory_percent"]))
        top = sorted(procs, key=lambda p: p.info["memory_percent"], reverse=True)[0]
        return top.info["name"], int(top.info["memory_percent"])
    except:
        return "Unknown", 0


def get_sys_info():
    # Temp with Device Name
    temp = 0
    temp_dev = "System"  # Default name

    try:
        temps = psutil.sensors_temperatures()
        # Map sensor names to readable labels
        sensor_map = {
            "coretemp": "CPU (Intel)",
            "k10temp": "CPU (AMD)",
            "amdgpu": "GPU",
            "acpitz": "ACPI Thermal",
        }

        for name in ["coretemp", "k10temp", "amdgpu", "acpitz"]:
            if name in temps:
                temp = temps[name][0].current
                temp_dev = sensor_map.get(name, name)
                break
    except:
        pass

    net_down, net_up = get_net_speed()
    gpu = get_gpu()
    hog_name, hog_val = get_top_hog()

    output = {
        "temp": int(temp),
        "temp_dev": temp_dev,  # Added Device Name
        "net_down": net_down,
        "net_up": net_up,  # Added Upload Speed
        "gpu": gpu,
        "hog_name": hog_name[:8],
        "hog_full": hog_name,  # Full name for tooltip
        "hog_val": hog_val,
    }
    print(json.dumps(output))


if __name__ == "__main__":
    get_sys_info()
