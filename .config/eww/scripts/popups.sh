#!/bin/bash

CMD=$1
TARGET=$2
CURRENT=$3

if [ -z "$CURRENT" ]; then
  CURRENT="none"
fi

# 1. DETERMINE VIEW INDEX
# We now map everything to a stack index inside 'center_popup'
VIEW=0
case $TARGET in
net) VIEW=1 ;;
bt) VIEW=2 ;;
audio) VIEW=3 ;;
notif) VIEW=4 ;;
clip) VIEW=5 ;;
esac

# 2. HANDLE CLOSE / TOGGLE
if [ "$CMD" == "close" ]; then
  eww update active_popup="none"
  eww close center_popup 2>/dev/null
  exit 0
fi

if [ "$CMD" == "toggle" ]; then
  if [ "$TARGET" == "$CURRENT" ]; then
    eww update active_popup="none"
    eww close center_popup 2>/dev/null
    exit 0
  fi
fi

# 3. OPEN / UPDATE
# Since everything is now in the same window, we treat it all as a transition.

# If the popup is NOT currently open (current == none), we must open the window.
if [ "$CURRENT" == "none" ]; then
  eww update active_popup="$TARGET" active_view=$VIEW
  eww open center_popup
else
  # If it IS open, we just update the variables to trigger the slide animation.
  # We do NOT run 'eww open' again, which prevents the Hyprland animation glitch.
  eww update active_popup="$TARGET" active_view=$VIEW
fi
