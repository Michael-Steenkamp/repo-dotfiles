#!/bin/bash

# 1. Set Paths
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"

# 2. Pick a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
echo "[LOG] Selected Wallpaper: $WALLPAPER"

# 3. Generate Colors (pywal16)
# -n: Skip setting wallpaper (let hyprpaper handle it)
# -i: Input image
wal -n -i "$WALLPAPER"

# 4. Update Hyprpaper
# We write the config for the next fresh boot...
cat >"$CONFIG_FILE" <<EOF
preload = $WALLPAPER
wallpaper = ,$WALLPAPER
EOF

# ...and apply it immediately to the running session
if pgrep -x "hyprpaper" >/dev/null; then
  hyprctl hyprpaper unload all
  hyprctl hyprpaper preload "$WALLPAPER"
  hyprctl hyprpaper wallpaper ",$WALLPAPER"
else
  hyprpaper &
fi

# 5. Reload Applications with New Colors

# Waybar: Send signal to reload style.css
pkill -SIGUSR2 waybar

# Dunst: Restart to load new config
pkill dunst
dunst &

# Hyprland: Reload to catch border colors
hyprctl reload

# -----------------------------------------------------
# 6. SIGNAL FISH TERMINALS
# Send SIGUSR1 to all fish instances.
# They will catch this signal and run 'update_wal_colors'
# defined in your config.fish.
# -----------------------------------------------------
pkill -SIGUSR1 fish

echo "[LOG] Theme updated."
