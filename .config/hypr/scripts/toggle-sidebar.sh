#!/bin/bash

# Check if the sidebar is currently open
if eww active-windows | grep -q "sidebar"; then
  # IF OPEN:
  # 1. Close the sidebar
  # 2. Close the center_popup (if it exists)
  eww close sidebar center_popup

  # 3. Reset the variable so the popup doesn't appear immediately next time
  eww update active_view="none"
else
  # IF CLOSED:
  # Open just the sidebar
  eww open sidebar
fi
