#!/bin/bash

STATE_FILE="/tmp/waybar_connection_state"

if ping -c 1 -W 1 1.1.1.1 > /dev/null 2>&1; then
    # Online: save and display connected
    echo "connected" > "$STATE_FILE"
    echo '{"text": "󰅠", "class": "connected"}'
else
    # Offline: check if previously connected
    if [[ -f "$STATE_FILE" && "$(cat "$STATE_FILE")" == "connected" ]]; then
        # Don't update UI on a single fail
        echo '{"text": "󰅠", "class": "connected"}'
    else
        echo "disconnected" > "$STATE_FILE"
        echo '{"text": "󰧠", "class": "disconnected"}'
    fi
fi
