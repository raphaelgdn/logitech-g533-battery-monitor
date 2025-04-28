#!/bin/bash
source "$HOME/.local/share/g533/scripts/env.sh"

battery_level=$(headsetcontrol -b 2>/dev/null | grep "Level:" | awk '{print $2}' | sed 's/%//')

if [[ -n "$battery_level" && "$battery_level" =~ ^[0-9]+$ ]]; then
  battery_float=$(echo "$battery_level/100" | bc -l)
  hours_left=$(echo "$battery_float * $FULL_BATTERY_HOURS" | bc -l)
  hours=$(echo "$hours_left" | awk -F. '{print $1}')
  minutes=$(echo "0.${hours_left#*.} * 60" | bc -l | awk -F. '{print $1}')
  time_left="${hours}h ${minutes}min"

  if [ "$battery_level" -le "$THRESHOLD_SHOW" ]; then
    notify-send -u normal -i battery-good-symbolic "🔋 Headset G533" "${battery_level}% de bateria — Estimado: ${time_left} restantes"
  fi
else
  echo "⚠️ Não foi possível obter o nível da bateria."
fi
