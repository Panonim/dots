#!/bin/bash

IFS=',' read -r usage temp vram_total vram_used power_draw <<< "$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.total,memory.used,power.draw --format=csv,noheader,nounits | head -n1)"

vram_used_gb=$(awk -v val="$vram_used" 'BEGIN {printf "%.1f", val/1024}')
vram_total_gb=$(awk -v val="$vram_total" 'BEGIN {printf "%.1f", val/1024}')

power_draw_int=$(printf "%.0f" "$power_draw")

text="󰾲   ${usage}% | ${temp}°C | ${vram_used_gb}GB | ${power_draw_int}W"

echo "{\"text\": \"$text\", \"tooltip\": \"GPU Usage: ${usage}%\\nTemp: ${temp}°C\\nVRAM Used: ${vram_used_gb}GB / ${vram_total_gb}GB\\nPower Draw: ${power_draw_int}W\"}"
