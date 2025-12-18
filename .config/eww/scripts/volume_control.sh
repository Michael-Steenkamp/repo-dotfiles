#!/bin/bash

# Usage:
# volume_control.sh set <value>
# volume_control.sh toggle

action=$1
val=$2

# Get the default sink (device) name to ensure we control the active one
DEFAULT_SINK="@DEFAULT_SINK@"

case $action in
set)
  # Round the input (Eww sliders sometimes send floats like 50.5)
  target=$(printf "%.0f" "$val")

  if [ "$target" -eq 0 ]; then
    # Mute if 0
    pactl set-sink-mute "$DEFAULT_SINK" 1
  else
    # Unmute and set volume
    # We add '%' to ensure pactl treats it as percentage, not raw integer
    pactl set-sink-mute "$DEFAULT_SINK" 0
    pactl set-sink-volume "$DEFAULT_SINK" "${target}%"
  fi
  ;;

toggle)
  pactl set-sink-mute "$DEFAULT_SINK" toggle
  ;;
esac
