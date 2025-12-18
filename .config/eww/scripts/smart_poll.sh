#!/bin/bash

MODE=$1

# --- CLIPBOARD MODE (Event-Driven) ---
if [ "$MODE" == "clip" ]; then
  FILE="$HOME/.config/clipse/clipboard_history.json"

  # 1. Print initial list immediately so Eww has data on boot
  ~/.config/eww/scripts/clipboard.py list

  # 2. Use inotifywait to block until the file is actually written to.
  #    -m: Monitor indefinitely
  #    -e close_write: Only trigger when writing finishes
  inotifywait -m -e close_write "$FILE" 2>/dev/null | while read -r _ _ _; do
    ~/.config/eww/scripts/clipboard.py list
  done
fi

# --- NOTIFICATION MODE (Polling) ---
# Dunst doesn't have a simple "wait" command, so polling is still necessary.
# However, we can optimize the check slightly.
if [ "$MODE" == "notif" ]; then
  LAST_COUNT=-1

  # 1. Print initial list
  ~/.config/eww/scripts/notifications.py list

  while true; do
    # Get total history count. fast and cheap.
    CURR_COUNT=$(dunstctl count history)

    # LOGIC CHECK:
    # If a notification arrives (+1) and one expires (-1) at the same time,
    # the count stays the same and we miss an update.
    # If you notice this happening, we can switch to checking the latest ID,
    # but that is slightly heavier on CPU. For now, count is fine.

    if [ "$CURR_COUNT" != "$LAST_COUNT" ]; then
      ~/.config/eww/scripts/notifications.py list
      LAST_COUNT="$CURR_COUNT"
    fi

    # 2s interval is a good balance for notifications
    sleep 2
  done
fi
