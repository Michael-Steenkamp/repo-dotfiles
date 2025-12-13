#!/bin/bash

# Check if the sidebar is currently open
# We use the variable 'sidebar_visible' which tracks the state more reliably than grep
IS_OPEN=$(eww get sidebar_visible)

if [ "$IS_OPEN" == "true" ]; then
  # --- CLOSING ---
  # 1. Close the sidebar AND all potential popups
  eww close sidebar center_popup notif_window clipboard_window 2>/dev/null

  # 2. Update variables:
  #    - sidebar_visible=false: Stops CPU/RAM polls
  #    - active_popup="none": REMOVES THE HIGHLIGHT from buttons (Net/BT)
  eww update sidebar_visible=false active_popup="none"

else
  # --- OPENING ---
  # 1. Reset state BEFORE opening
  #    - active_popup="none": Ensures we start with no buttons highlighted
  #    - active_view=0: Resets the popup stack to the placeholder
  eww update sidebar_visible=true active_popup="none" active_view=0

  # 2. Open the sidebar
  eww open sidebar
fi
