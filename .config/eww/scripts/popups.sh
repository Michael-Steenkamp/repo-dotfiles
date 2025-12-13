#!/bin/bash

CMD=$1
TARGET=$2
CURRENT=$(eww get active_popup)

# 1. SMART CLOSE: Only close the window that is actually open
if [ "$CURRENT" == "clip" ]; then
  eww close clipboard_window
elif [ "$CURRENT" == "notif" ]; then
  eww close notif_window
elif [ "$CURRENT" != "none" ]; then
  # Catches net, bt, audio (which all use center_popup)
  eww close center_popup
fi

if [ "$CMD" == "close" ]; then
  eww update active_popup="none"
  exit 0
fi

if [ "$CMD" == "toggle" ]; then
  if [ "$TARGET" == "$CURRENT" ]; then
    eww update active_popup="none"
    exit 0
  fi
fi

eww update active_popup="$TARGET"

case $TARGET in
net)
  eww update active_view=1
  eww open center_popup
  ;;
bt)
  eww update active_view=2
  eww open center_popup
  ;;
audio)
  eww update active_view=3
  eww open center_popup
  ;;
notif)
  eww open notif_window
  ;;
clip)
  eww open clipboard_window
  ;;
esac
