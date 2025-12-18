#!/bin/bash
LOCK_FILE="/tmp/eww_sidebar_toggle.lock"

# --- SELF-CORRECTION: Remove Stale Locks ---
# If the lock file exists and is older than 2 seconds, delete it.
# This fixes the "it doesn't work after nuke" issue.
if [ -f "$LOCK_FILE" ]; then
  # Get current time and file modification time
  NOW=$(date +%s)
  FILE_TIME=$(stat -c %Y "$LOCK_FILE")
  AGE=$((NOW - FILE_TIME))

  if [ $AGE -gt 2 ]; then
    rm -f "$LOCK_FILE"
  fi
fi

# --- STANDARD LOCKING ---
exec 200>"$LOCK_FILE"
# Try to get lock. If fail (because another REAL instance is running), exit.
flock -n 200 || exit 1

# --- LOGIC ---
# We check Hyprland layers specifically, as Eww lives in the overlay layer.
IS_OPEN=$(hyprctl layers -j | grep -c '"namespace": "sidebar"')

if [ "$IS_OPEN" -gt 0 ]; then
  # It's open. CLOSE IT.
  eww close sidebar center_popup notif_window clipboard_window 2>/dev/null
  eww update sidebar_visible=false active_popup="none" active_view=0
else
  # It's closed. OPEN IT.
  eww update sidebar_visible=true active_popup="none" active_view=0
  eww open sidebar
fi
