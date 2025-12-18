#!/bin/bash
LOG="/tmp/eww_toggle_debug.log"

echo "========================================" >>"$LOG"
echo "[$(date '+%H:%M:%S')] SCRIPT START" >>"$LOG"

# 1. Lock File Check
LOCK_FILE="/tmp/eww_sidebar_toggle.lock"
if [ -f "$LOCK_FILE" ]; then
  AGE=$(($(date +%s) - $(stat -c %Y "$LOCK_FILE")))
  echo "[INFO] Lock file exists. Age: ${AGE}s" >>"$LOG"
  if [ $AGE -gt 2 ]; then
    echo "[WARN] Stale lock detected (older than 2s). Force removing." >>"$LOG"
    rm -f "$LOCK_FILE"
  fi
fi

exec 200>"$LOCK_FILE"
if ! flock -n 200; then
  echo "[ERROR] Could not acquire lock. Script already running?" >>"$LOG"
  exit 1
fi
echo "[INFO] Lock acquired." >>"$LOG"

# 2. State Check (The most critical part)
# We check Hyprland 'layers' because that is where Eww lives.
LAYERS_JSON=$(hyprctl layers -j)
IS_OPEN=$(echo "$LAYERS_JSON" | grep -c '"namespace": "sidebar"')

echo "[INFO] Hyprland Layer Check: Found $IS_OPEN instances of 'sidebar'." >>"$LOG"

if [ "$IS_OPEN" -gt 0 ]; then
  echo "[ACTION] DETECTED OPEN -> CLOSING" >>"$LOG"

  # Capture potential errors during close
  ERR=$(eww close sidebar center_popup notif_window clipboard_window 2>&1)
  echo "[EWW OUTPUT] Close: $ERR" >>"$LOG"

  eww update sidebar_visible=false active_popup="none" active_view=0 >>"$LOG" 2>&1
else
  echo "[ACTION] DETECTED CLOSED -> OPENING" >>"$LOG"

  # Capture potential errors during open
  ERR=$(eww open sidebar 2>&1)
  echo "[EWW OUTPUT] Open: $ERR" >>"$LOG"

  eww update sidebar_visible=true active_popup="none" active_view=0 >>"$LOG" 2>&1
fi

echo "[$(date '+%H:%M:%S')] SCRIPT FINISH" >>"$LOG"
echo "----------------------------------------" >>"$LOG"
