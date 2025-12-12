#!/bin/bash

CMD=$1
TARGET=$2
CURRENT=$(eww get active_popup)

# 1. Close ALL possible windows (Added clipboard_window)
eww close center_popup notif_window clipboard_window 2>/dev/null

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
