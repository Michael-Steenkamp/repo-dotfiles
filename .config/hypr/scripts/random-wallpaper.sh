#!/bin/bash

# 1. Set Paths
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"

# 2. Pick a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# 3. Write config and reload Hyprpaper (Silent)
cat >"$CONFIG_FILE" <<EOF
preload = $WALLPAPER
wallpaper = ,$WALLPAPER
EOF

if pgrep -x "hyprpaper" >/dev/null; then
  hyprctl hyprpaper unload all >/dev/null 2>&1
  hyprctl hyprpaper preload "$WALLPAPER" >/dev/null 2>&1
  hyprctl hyprpaper wallpaper ",$WALLPAPER" >/dev/null 2>&1
else
  hyprpaper >/dev/null 2>&1 &
fi

# 4. Generate Colors (Silent)
# -q suppresses output, so you don't see "image: ..." text
wallust run -q "$WALLPAPER"

# 5. Reload Applications
pkill -SIGUSR2 waybar
pkill dunst && dunst >/dev/null 2>&1 &

# 6. Reload Hyprland variables silently
# We don't need to source the file here if we reload Hyprland config completely,
# but using hyprctl is faster/smoother.
source "$HOME/.cache/wal/colors.sh"
ACT_BORDER="0xff${color1:1} 0xff${color10:1} 45deg"
INACT_BORDER="0xff${background:1}"

hyprctl keyword general:col.active_border "$ACT_BORDER" >/dev/null 2>&1
hyprctl keyword general:col.inactive_border "$INACT_BORDER" >/dev/null 2>&1

# 7. Reload Terminals (The Clean Way)
# SIGUSR1 tells Kitty to reload its config file (colors-kitty.conf)
# It does NOT require printing 'sequences' to the terminal.
pkill -SIGUSR1 kitty

# Reload Fish vars (if you use them for syntax highlighting)
# Ensure your fish trap just sources the file, DOES NOT cat sequences.
pkill -SIGUSR1 fish
