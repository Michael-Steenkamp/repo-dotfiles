#!/bin/bash

MODE=$1
INTERVAL=2

# --- CLIPBOARD MODE ---
if [ "$MODE" == "clip" ]; then
  FILE="$HOME/.config/clipse/clipboard_history.json"
  LAST_TIME=0

  # 1. Print initial list immediately
  ~/.config/eww/scripts/clipboard.py list

  while true; do
    # Get the file modification time
    # If file doesn't exist, curr_time is 0
    CURR_TIME=$(stat -c %Y "$FILE" 2>/dev/null || echo 0)

    if [ "$CURR_TIME" != "$LAST_TIME" ]; then
      ~/.config/eww/scripts/clipboard.py list
      LAST_TIME="$CURR_TIME"
    fi

    sleep $INTERVAL
  done
fi

# --- NOTIFICATION MODE ---
if [ "$MODE" == "notif" ]; then
  LAST_COUNT=-1

  # 1. Print initial list immediately
  ~/.config/eww/scripts/notifications.py list

  while true; do
    # Check how many items are in history
    # (Using 'count' is much faster than fetching the whole history)
    CURR_COUNT=$(dunstctl count history)

    if [ "$CURR_COUNT" != "$LAST_COUNT" ]; then
      ~/.config/eww/scripts/notifications.py list
      LAST_COUNT="$CURR_COUNT"
    fi

    sleep $INTERVAL
  done
fi
