#!/bin/bash
if [ ! -f /tmp/waybar.pinned ]; then
    killall waybar
fi
