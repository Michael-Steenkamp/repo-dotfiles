#!/bin/bash

# Define a temporary file location
TMP_FILE="/tmp/screenshot_preview.png"

# 1. Capture the region to the temp file
#    The 'if' ensures we only run the rest if you actually select a region (didn't press Esc)
if grim -g "$(slurp)" "$TMP_FILE"; then

  # 2. Copy the image from the file to the clipboard
  wl-copy <"$TMP_FILE"

  # 3. Send the notification
  #    -a "grim": Sets the application name to "grim" (instead of notify-send)
  #    -i "$TMP_FILE": Uses the screenshot itself as the icon preview
  notify-send -a "grim" -i "$TMP_FILE" "Screenshot" "Copied to clipboard"
fi
