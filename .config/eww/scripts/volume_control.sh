#!/bin/bash

# Usage:
# volume_control.sh set <value>  (For Sliders)
# volume_control.sh toggle       (For Buttons)

action=$1
val=$2

case $action in
set)
  # Round the input (Eww sliders sometimes send floats like 50.5)
  target=$(printf "%.0f" "$val")

  if [ "$target" -eq 0 ]; then
    # If sliding to 0, ensure we actually MUTE
    pamixer --set-volume 0
    pamixer --mute
  else
    # If sliding up, ensure we UNMUTE first
    pamixer --unmute
    pamixer --set-volume "$target"
  fi
  ;;

toggle)
  pamixer -t
  ;;
esac
