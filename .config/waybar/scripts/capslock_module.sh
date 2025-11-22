#!/bin/bash
# Check if Caps Lock LED is on (1) or off (0)
if grep -q 1 /sys/class/leds/*capslock*/brightness 2>/dev/null; then
  # Output the Icon when Locked
  echo '{"text": "", "class": "locked", "tooltip": "Caps Lock is ON"}'
else
  # We output the same icon when unlocked, but CSS will shrink it to 0 size
  echo '{"text": "", "class": "unlocked", "tooltip": "Caps Lock is OFF"}'
fi
