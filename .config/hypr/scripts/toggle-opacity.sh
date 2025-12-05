#!/usr/bin/env bash

# --- Ensure tools are found when run by keybind ---
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin

# 1. Get the current active window's information as JSON
window_info=$(hyprctl activewindow -j)

# Safety check: Exit if no window is focused or found
if [[ -z "$window_info" || "$window_info" == "{}" || "$window_info" == "null" ]]; then
  exit 0
fi

# Extract Address (unique ID), Class, and PID using jq
addr=$(echo "$window_info" | jq -r ".address")
class=$(echo "$window_info" | jq -r ".class")
pid=$(echo "$window_info" | jq -r ".pid")

# 2. Define State File (Tracks if this specific window is currently "Opaque Mode")
state_file="/tmp/hypr_opacity_${addr}.lock"

# 3. Determine Defaults from Config Files (Strict Parsing)
# Hyprland: Find 'active_opacity' (ignoring comments), default to 0.85 if missing
default_hypr_opacity=$(grep "^[[:space:]]*active_opacity" ~/.config/hypr/hyprland.conf | awk -F '=' '{print $2}' | tr -d ' ' | head -n 1)
if [[ -z "$default_hypr_opacity" ]]; then
  default_hypr_opacity="0.85"
fi

# Kitty: Find 'background_opacity' (start of line only), default to 0.5 if missing
default_kitty_opacity=$(grep "^background_opacity" ~/.config/kitty/kitty.conf | awk '{print $2}' | head -n 1)
if [[ -z "$default_kitty_opacity" ]]; then
  default_kitty_opacity="0.5"
fi

# Helper function to change Kitty opacity
change_kitty_opacity() {
  local opacity=$1
  local socket=""

  # Try to find the correct socket
  if [ -S "/tmp/kitty-${pid}" ]; then
    socket="unix:/tmp/kitty-${pid}"
  elif [ -S "/tmp/mykitty" ]; then
    socket="unix:/tmp/mykitty"
  fi

  if [ -n "$socket" ]; then
    kitten @ --to "$socket" set-background-opacity "$opacity"
  else
    # Critical Fallback: Notify user if socket is missing
    notify-send -u critical "Opacity Toggle Failed" "Socket /tmp/kitty-${pid} not found.\nPlease completely restart Kitty to apply 'listen_on' settings."
  fi
}

# 4. Toggle Logic
if [[ -f "$state_file" ]]; then
  # --- TOGGLE OFF: Go back to Acrylic (Transparent) ---

  # Revert Hyprland window to config value
  hyprctl dispatch setprop address:$addr alpha "$default_hypr_opacity" lock

  # Revert Kitty background to config value
  if [[ "$class" == "kitty" ]]; then
    change_kitty_opacity "$default_kitty_opacity"
  fi

  rm "$state_file"
else
  # --- TOGGLE ON: Go Fully Opaque (Solid) ---

  # Force Hyprland window to 1.0
  hyprctl dispatch setprop address:$addr alpha 1.0 lock

  # Force Kitty background to 1.0
  if [[ "$class" == "kitty" ]]; then
    change_kitty_opacity "1.0"
  fi

  touch "$state_file"
fi
