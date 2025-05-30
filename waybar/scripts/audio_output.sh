#!/bin/bash

SIGNAL_NUMBER=10

get_default_sink() {
    pactl info | awk -F ': ' '/Default Sink/ {print $2}'
}

get_sink_icon() {
    local sink muted description
    sink=$(get_default_sink)
    muted=$(pactl get-sink-mute "$sink" | awk '{print $2}')

    description=$(pactl list sinks | awk -v sink="$sink" '
        $0 ~ "Name: "sink { show=1 }
        show && /Description:/ {
            print $2; for(i=3;i<=NF;++i) printf(" %s", $i); exit
        }
    ')

    if [[ "$muted" == "yes" ]]; then
        echo "󰝟"  # muted
    elif [[ "$description" =~ [Hh]eadphones ]]; then
        echo ""  # headphones
    elif [[ "$description" =~ [Ss]peaker ]]; then
        echo ""  # speakers
    else
        echo ""  # fallback
    fi
}

get_volume_percent() {
    local sink
    sink=$(get_default_sink)
    pactl get-sink-volume "$sink" | awk '{print $5}' | head -n1
}

toggle_mute() {
    pactl set-sink-mute "$(get_default_sink)" toggle
    pkill -RTMIN+${SIGNAL_NUMBER} waybar
}

change_volume() {
    local sink step="5%"
    sink=$(get_default_sink)
    if [[ "$1" == "up" ]]; then
        pactl set-sink-volume "$sink" +$step
    else
        pactl set-sink-volume "$sink" -$step
    fi
    pkill -RTMIN+${SIGNAL_NUMBER} waybar
}

case "$1" in
    toggle)
        toggle_mute
        ;;
    volume-up)
        change_volume up
        ;;
    volume-down)
        change_volume down
        ;;
    *)
        ICON=$(get_sink_icon)
        VOLUME=$(get_volume_percent)
        echo "{\"text\": \"$ICON\", \"tooltip\": \"Volume: $VOLUME\"}"
        ;;
esac

