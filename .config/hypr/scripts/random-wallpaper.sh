#!/bin/bash

# 1. Set Paths
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"

# 2. Pick a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
echo "[LOG] Selected Wallpaper: $WALLPAPER"

# -----------------------------------------------------
# 3. Apply Wallpaper VISUALLY First
# -----------------------------------------------------

# Write the config for the next fresh boot
cat >"$CONFIG_FILE" <<EOF
preload = $WALLPAPER
wallpaper = ,$WALLPAPER
EOF

# Apply it immediately to the running session
if pgrep -x "hyprpaper" >/dev/null; then
  hyprctl hyprpaper unload all
  hyprctl hyprpaper preload "$WALLPAPER"
  hyprctl hyprpaper wallpaper ",$WALLPAPER"
else
  hyprpaper &
fi

# -----------------------------------------------------
# 4. WAIT
# Give the wallpaper 0.5 - 1 second to transition
# before changing the UI colors.
# -----------------------------------------------------
sleep 1

# -----------------------------------------------------
# 5. Generate Colors (pywal16)
# Now that the wallpaper is visible, generate the palette.
# -----------------------------------------------------
# -n: Skip setting wallpaper (we already did it above)
# -i: Input image
wal -n -i "$WALLPAPER"

# -----------------------------------------------------
# 6. Reload Applications with New Colors
# -----------------------------------------------------

# Waybar: Send signal to reload style.css
pkill -SIGUSR2 waybar

# Dunst: Restart to load new config
pkill dunst
dunst &

# -----------------------------------------------------
# 6b. Update Hyprland Colors Dynamically (No Reload)
# -----------------------------------------------------
# Source the generated colors from pywal so we can use them
source "$HOME/.cache/wal/colors.sh"

# strip the '#' symbol and add transparency if needed
ACT_BORDER="0xff${color1:1} 0xff${color10:1} 45deg"
INACT_BORDER="0xff${background:1}"

# Inject the new values directly into the running Hyprland session
hyprctl keyword general:col.active_border "$ACT_BORDER"
hyprctl keyword general:col.inactive_border "$INACT_BORDER"

# -----------------------------------------------------
# 7. SIGNAL FISH TERMINALS
# -----------------------------------------------------
pkill -SIGUSR1 fish

echo "[LOG] Theme updated."
