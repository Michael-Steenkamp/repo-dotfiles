#!/usr/bin/env python3
import json
import sys

import requests

# CHANGE THIS to your city if auto-detection fails (e.g., "London")
CITY = ""


def get_weather():
    try:
        # Request JSON data from wttr.in
        url = f"https://wttr.in/{CITY}?format=j1"
        response = requests.get(url, timeout=5)
        data = response.json()

        current = data["current_condition"][0]

        # Extract details
        temp_C = current["temp_C"]
        desc = current["weatherDesc"][0]["value"]
        feels_like = current["FeelsLikeC"]
        humidity = current["humidity"]

        # Map some common icons (optional, wttr usually provides text, but we can use Nerd Fonts)
        # For simplicity, we'll use the wttr text or a generic icon set if you prefer.
        # Here we just return the text format from wttr for simplicity + the Icon.

        # Let's use a simpler text format for the bar to keep it clean
        text = f"{temp_C}°C"

        # Tooltip shows more detail
        tooltip = f"<b>{desc}</b>\nFeels like: {feels_like}°C\nHumidity: {humidity}%"

        # Determine icon based on description (Basic mapping)
        # You can expand this list
        icon = " "  # Cloud default
        d_lower = desc.lower()
        if "sun" in d_lower or "clear" in d_lower:
            icon = " "
        elif "rain" in d_lower or "shower" in d_lower:
            icon = " "
        elif "snow" in d_lower:
            icon = " "
        elif "cloud" in d_lower or "overcast" in d_lower:
            icon = " "
        elif "thunder" in d_lower:
            icon = " "

        out_data = {"text": f"{icon} {text}", "tooltip": tooltip, "class": "weather"}

        print(json.dumps(out_data))

    except Exception as e:
        # Fallback if offline
        print(json.dumps({"text": " ", "tooltip": "Offline"}))


if __name__ == "__main__":
    get_weather()
