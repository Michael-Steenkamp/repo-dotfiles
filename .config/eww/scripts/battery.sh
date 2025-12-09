#!/bin/bash

# Efficiently dump all power devices in one go
upower --dump | awk '
BEGIN {
    # Start the JSON array
    print "["
    count = 0
    RS = ""      # Blank line separates records (blocks)
    FS = "\n"    # Newline separates fields within a block
}

{
    # Reset variables for each record
    path = ""; model = ""; state = ""; percent = ""; is_line = 0; native_path = ""

    # Parse fields
    for (i=1; i<=NF; i++) {
        # Trim whitespace
        gsub(/^[ \t]+|[ \t]+$/, "", $i)

        # Capture specific fields
        if ($i ~ /^Device:/) path = $i
        if ($i ~ /^native-path:/) {
            split($i, a, ":"); native_path = a[2]; gsub(/^[ \t]+/, "", native_path)
        }
        if ($i ~ /^model:/) {
            split($i, a, ":"); model = a[2]; gsub(/^[ \t]+/, "", model)
        }
        if ($i ~ /^state:/) {
            split($i, a, ":"); state = a[2]; gsub(/^[ \t]+/, "", state)
        }
        if ($i ~ /^percentage:/) {
            split($i, a, ":"); percent = a[2]; gsub(/%/, "", percent); gsub(/^[ \t]+/, "", percent)
        }
        if ($i ~ /line_power/) is_line = 1
    }

    # --- UNIVERSAL FILTERS ---

    # 1. Skip Line Power (AC Adapter)
    if (is_line == 1) next

    # 2. Skip DisplayDevice (The "Ghost" Aggregate Device)
    # This often mirrors the main battery and causes duplicates
    if (path ~ /DisplayDevice/) next

    # 3. Skip Internal Batteries (The "Dell" or "ThinkPad" main battery)
    # We identify this by the native-path usually being "BAT0", "BAT1", etc.
    if (native_path ~ /BAT/) next

    # 4. Skip devices with NO MODEL NAME
    # (Prevents nameless system controllers from showing up)
    if (model == "") next

    # 5. Skip if no percentage
    if (percent == "") next

    # --- ICON LOGIC ---
    icon = ""
    path_lower = tolower(path)
    if (path_lower ~ /mouse/) icon = "󰍽"
    else if (path_lower ~ /keyboard/) icon = "󰌌"
    else if (path_lower ~ /headset/) icon = "󰋋"
    else if (path_lower ~ /phone/) icon = ""
    else if (path_lower ~ /wacom|tablet/) icon = "󰕙"
    else if (path_lower ~ /gamepad|controller/) icon = "󰊴"

    # --- OUTPUT ---
    if (count > 0) print ","
    printf "{\"name\": \"%s\", \"icon\": \"%s\", \"percent\": \"%s\", \"state\": \"%s\", \"type\": \"device\"}", model, icon, percent, state
    count++
}

END {
    print "]"
}
'
