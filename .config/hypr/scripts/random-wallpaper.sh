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
# -q: Quiet mode (optional)
wal -n -i "$WALLPAPER"

# 4. Update Hyprpaper
# We write the config for the next fresh boot...
cat >"$CONFIG_FILE" <<EOF
preload = $WALLPAPER
wallpaper = ,$WALLPAPER
EOF

# ...and apply it immediately to the running session
if pgrep -x "hyprpaper" >/dev/null; then
  # If hyprpaper is running, use IPC to avoid restarting it (smoother)
  hyprctl hyprpaper unload all
  hyprctl hyprpaper preload "$WALLPAPER"
  hyprctl hyprpaper wallpaper ",$WALLPAPER"
else
  # If not running (fresh boot), start it
  hyprpaper &
fi

# 5. Reload Applications with New Colors

# Waybar: Send signal to reload style.css
pkill -SIGUSR2 waybar

# Dunst: Restart to load new config
pkill dunst
dunst &

# Hyprland: Reload to catch border colors (if you use pywal colors in hyprland.conf)
hyprctl reload

echo "[LOG] Theme updated."
