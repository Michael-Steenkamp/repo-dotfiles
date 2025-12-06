#!/bin/bash

# 1. Set Paths
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"
CACHE_DIR="$HOME/.cache/wallust-schemes"
mkdir -p "$CACHE_DIR"

# 2. Pick a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
  notify-send "Wallpaper Error" "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

cat >"$CONFIG_FILE" <<EOF
preload = $WALLPAPER
wallpaper = ,$WALLPAPER
EOF

# --- UPDATED STEP 3: Self-Healing Logic ---
if pgrep -x "hyprpaper" >/dev/null; then
  # Try to preload with a 1-second timeout
  # If this hangs (exit code 124), the daemon is frozen.
  if timeout 1s hyprctl hyprpaper preload "$WALLPAPER" >/dev/null 2>&1; then
    # SUCCESS: Daemon is healthy. Apply wallpaper.
    hyprctl hyprpaper wallpaper ",$WALLPAPER" >/dev/null 2>&1

    # Clean up old images in the background safely
    (sleep 1 && hyprctl hyprpaper unload all) >/dev/null 2>&1 &
  else
    # FAILURE: Daemon is stuck. Kill it and let it restart.
    # The new instance will read the config file we just wrote above.
    pkill -9 hyprpaper
    hyprpaper >/dev/null 2>&1 &
  fi
else
  # Not running? Just start it.
  hyprpaper >/dev/null 2>&1 &
fi

# 4. Generate Colors (Smart Caching)
WALLPAPER_NAME=$(basename "$WALLPAPER")
CACHE_FILE="$CACHE_DIR/${WALLPAPER_NAME%.*}.json"

if [ -f "$CACHE_FILE" ]; then
  # HIT: Load cached scheme
  wallust cs "$CACHE_FILE"
else
  # MISS: Generate new scheme
  if wallust run -q "$WALLPAPER"; then
    if [ -f "$HOME/.cache/wal/colors.json" ]; then
      cp "$HOME/.cache/wal/colors.json" "$CACHE_FILE"
    else
      notify-send "Wallust Error" "colors.json was NOT generated. Check wallust.toml template."
    fi
  else
    notify-send "Wallust Failed" "Could not run wallust on $WALLPAPER_NAME"
  fi
fi

# 5. Reload Applications
killall -USR2 waybar
pkill dunst && dunst >/dev/null 2>&1 &
hyprctl reload >/dev/null 2>&1
pkill -SIGUSR1 kitty
pkill -SIGUSR1 fish
pkill -SIGUSR1 nvim
pkill dunst && dunst &
