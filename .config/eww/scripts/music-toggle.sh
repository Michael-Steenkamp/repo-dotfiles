#!/bin/bash

# 1. Get current status directly from Eww variable (faster than querying playerctl)
STATUS=$(eww get music | jq -r .status)

# 2. Determine the OPPOSITE icon (Optimistic Update)
if [[ "$STATUS" == "Playing" ]]; then
  # If currently playing, we are pausing -> Show "Play" icon
  ICON="󰐊"
else
  # If currently paused, we are playing -> Show "Pause" icon
  ICON="󰏤"
fi

# 3. Apply the override INSTANTLY
eww update music_opt_icon="$ICON"

# 4. Send the command to Spotify
playerctl -p spotify_player,spotify,%any play-pause

# 5. Wait long enough for Spotify to catch up (2 seconds), then clear override
sleep 5
eww update music_opt_icon=""
