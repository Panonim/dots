#!/bin/bash
if ping -c 1 -W 1 8.8.8.8 > /dev/null 2>&1; then
    echo '{"text": "󰅠", "class": "connected"}'
else
    echo '{"text": "󰧠", "class": "disconnected"}'
fi
