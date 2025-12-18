#!/bin/bash
# NUCLEAR RESET ☢️

# 1. Kill processes
pkill -9 -f toggle-sidebar.sh
pkill -9 -f eww

# 2. Remove locks AND the socket
rm -f /tmp/eww_sidebar_toggle.lock
rm -f /tmp/eww-server_* # 3. Reset Systemd
systemctl --user stop eww
systemctl --user reset-failed eww

# 4. Start fresh daemon (Wait a moment for socket to clear)
sleep 0.5
systemctl --user start eww

notify-send "Eww System" "Daemon restarted manually." -u normal
