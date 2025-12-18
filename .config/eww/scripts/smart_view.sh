#!/bin/bash

# Arguments:
# 1. TYPE         : "clip" or "notif"
# 2. CLICKED_ID   : The ID of the item clicked
# 3. VIEWED_ID    : The ID currently being displayed
# 4. ACTIVE_POPUP : The name of the currently open popup window
# 5. PAYLOAD      : (Optional) Raw JSON content for notifications

TYPE=$1
CLICKED_ID=$2
VIEWED_ID=$3
ACTIVE_POPUP=$4
PAYLOAD=$5

# LOGIC:
# 1. SAME ITEM + ALREADY OPEN -> Close it.
if [[ "$ACTIVE_POPUP" == "$TYPE" && "$CLICKED_ID" == "$VIEWED_ID" ]]; then
  ~/.config/eww/scripts/popups.sh close
else
  # 2. Update Content
  if [ "$TYPE" == "clip" ]; then
    RAW_JSON=$(~/.config/eww/scripts/clipboard.py inspect "$CLICKED_ID")
    FINAL_JSON=$(python3 -c "import json, sys; d=json.loads(sys.argv[1]); d['id']='$CLICKED_ID'; print(json.dumps(d))" "$RAW_JSON")
    eww update viewed_clip="$FINAL_JSON"

  elif [ "$TYPE" == "notif" ]; then
    eww update viewed_notif="$PAYLOAD"
  fi

  # 3. Open Window (Pass ACTIVE_POPUP so it doesn't re-animate!)
  if [[ "$ACTIVE_POPUP" != "$TYPE" ]]; then
    ~/.config/eww/scripts/popups.sh open "$TYPE" "$ACTIVE_POPUP"
  fi
fi
