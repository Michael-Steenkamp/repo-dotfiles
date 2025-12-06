#!/bin/bash

# Check if the sidebar is currently open
if eww active-windows | grep -q "sidebar"; then
  # IF OPEN:
  # 1. Close both windows
  eww close sidebar center_popup

  # 2. Update variables: Stop ALL polls
  eww update sidebar_visible=false popup_visible=false active_view="none"
else
  # IF CLOSED:
  # 1. Update variable: Start Sidebar polls ONLY
  eww update sidebar_visible=true

  # 2. Open the sidebar
  eww open sidebar
fi
