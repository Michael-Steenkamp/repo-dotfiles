#!/bin/bash

# 1. Set Paths
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"
CACHE_DIR="$HOME/.cache/wallust_cache"

# Ensure cache directory exists
mkdir -p "$CACHE_DIR"

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

# 4. Generate Colors (Smart Caching)
# Generate a unique filename based on the wallpaper path (flattened)
CACHE_FILE="$CACHE_DIR/$(echo "$WALLPAPER" | sed 's/\//_/g').json"

if [ -f "$CACHE_FILE" ]; then
  # HIT: Load cached scheme instantly (skips image processing)
  # This applies all your templates (kitty, waybar, etc.) automatically
  wallust cs "$CACHE_FILE"
else
  # MISS: Generate new scheme (slower) and save to cache
  # -q suppresses output
  wallust run -q "$WALLPAPER"

  # Save the generated json to our cache folder
  # Wallust v3 defaults to ~/.cache/wallust/wallust.json for the current state
  cp "$HOME/.cache/wallust/wallust.json" "$CACHE_FILE"
fi

# 5. Reload Applications
pkill -SIGUSR2 waybar
pkill dunst && dunst >/dev/null 2>&1 &

# 6. Reload Hyprland variables silently
source "$HOME/.cache/wal/colors.sh"
ACT_BORDER="0xff${color1:1} 0xff${color10:1} 45deg"
INACT_BORDER="0xff${background:1}"

hyprctl keyword general:col.active_border "$ACT_BORDER" >/dev/null 2>&1
hyprctl keyword general:col.inactive_border "$INACT_BORDER" >/dev/null 2>&1

# 7. Reload Terminals
# SIGUSR1 tells Kitty to reload config
pkill -SIGUSR1 kitty

# Reload Fish vars
pkill -SIGUSR1 fish
