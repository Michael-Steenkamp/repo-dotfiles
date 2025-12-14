#!/bin/bash
# FORCE RESET: Unconditionally kills everything related to Eww.

# 1. Kill the toggle script if it's stuck waiting
pkill -9 -f toggle-sidebar.sh

# 2. Kill the Eww binary immediately (Signal 9 = No mercy)
pkill -9 -f eww

# 3. Clean up the lock files so the next toggle works
rm -f /tmp/eww-sidebar-exec.lock
rm -f /tmp/eww-sidebar-state
rm -f /tmp/eww-sidebar-cooldown

# 4. Tell Systemd that we manually killed it (prevents it from getting confused)
systemctl --user reset-failed eww

# 5. Start it fresh
systemctl --user start eww

# 6. Notify you it's done
notify-send "Eww System" "NUCLEAR RESET COMPLETE ☢️" -u critical
