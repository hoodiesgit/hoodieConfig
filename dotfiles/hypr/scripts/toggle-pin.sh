#!/bin/bash

LOCK_FILE="/tmp/waybar.pinned"
MONITOR=$(hyprctl -j monitors | jq -r '.[] | select(.focused) | .name')

if [ -f "$LOCK_FILE" ]; then
    # Bar is currently pinned, so unpin it
    rm "$LOCK_FILE"
    hyprctl keyword monitor "$MONITOR,addreserved,0,0,0,0"
    killall waybar
else
    # Bar is not pinned, so pin it
    touch "$LOCK_FILE"
    hyprctl keyword monitor "$MONITOR,addreserved,5,0,0,0" # Reserve 5px at the top
    waybar &
fi
