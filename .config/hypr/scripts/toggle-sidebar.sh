#!/bin/bash

IS_OPEN=$(eww get sidebar_visible)

if [ "$IS_OPEN" == "true" ]; then
  # --- CLOSING ---

  # 1. Close the sidebar AND all popups
  eww close sidebar center_popup notif_window clipboard_window 2>/dev/null

  # 2. Update state variables to FALSE
  eww update sidebar_visible=false active_popup="none" active_view=0

else
  # --- OPENING ---

  # 1. Ensure all other EWW popups are closed before opening the main sidebar (Added safeguard)
  eww close center_popup notif_window clipboard_window 2>/dev/null

  # 2. Update state variables to TRUE
  eww update sidebar_visible=true active_popup="none" active_view=0

  # 3. Open the sidebar
  eww open sidebar
fi
