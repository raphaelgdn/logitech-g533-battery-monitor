#!/bin/bash
source "$HOME/.local/share/g533/scripts/env.sh"

battery_level=$(headsetcontrol -b 2>/dev/null | grep "Level:" | awk '{print $2}' | sed 's/%//')

if [[ -n "$battery_level" && "$battery_level" =~ ^[0-9]+$ ]]; then
  if [ -f "$LAST_BATTERY_FILE" ]; then
    last_battery=$(cat "$LAST_BATTERY_FILE")
  else
    last_battery=$battery_level
  fi

  if [ "$battery_level" -gt "$last_battery" ]; then
    status="Carregando 🔋"
  elif [ "$battery_level" -lt "$last_battery" ]; then
    status="Descendo ⚡"
  else
    status="Estável ⏸️"
  fi

  echo "$battery_level" > "$LAST_BATTERY_FILE"
  echo "$(date '+%Y-%m-%d %H:%M') - Bateria: ${battery_level}% - $status" >> "$LOG_FILE"

  battery_float=$(echo "$battery_level/100" | bc -l)
  hours_left=$(echo "$battery_float * $FULL_BATTERY_HOURS" | bc -l)
  hours=$(echo "$hours_left" | awk -F. '{print $1}')
  minutes=$(echo "0.${hours_left#*.} * 60" | bc -l | awk -F. '{print $1}')
  time_left="${hours}h ${minutes}min"

  if [ "$battery_level" -le "$THRESHOLD_CRITICAL" ]; then
    CURRENT_VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)
    pactl set-sink-volume @DEFAULT_SINK@ 15%
    timeout 2s paplay "$SOUND_PATH"
    pactl set-sink-volume @DEFAULT_SINK@ "${CURRENT_VOLUME}%"
    zenity --warning --title="⚡ BATERIA CRÍTICA - G533" --text="Bateria: ${battery_level}%\nTempo restante: ${time_left}" --width=400 --height=200

  elif [ "$battery_level" -le "$THRESHOLD_LOW" ]; then
    notify-send -u critical -i battery-caution-symbolic "🔋 Headset G533" "Bateria baixa: ${battery_level}%\nTempo restante: ${time_left}"
  elif [ "$battery_level" -le 50 ]; then
    notify-send -u normal -i battery-low-symbolic "🔋 Headset G533" "Bateria moderada: ${battery_level}%\nTempo restante: ${time_left}"
  fi
else
  echo "⚠️ Não foi possível ler a bateria."
fi
