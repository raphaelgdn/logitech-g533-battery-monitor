#!/bin/bash
source "$HOME/.local/share/g533/scripts/env.sh"

if [ ! -f "$LOG_FILE" ]; then
  echo "❌ Arquivo de log não encontrado."
  exit 1
fi

battery_level=$(headsetcontrol -b 2>/dev/null | grep "Level:" | awk '{print $2}' | sed 's/%//')

last_percent=""
last_time=""
total_minutes=0
total_carga=0

while IFS= read -r line; do
  timestamp=$(echo "$line" | awk '{print $1" "$2}')
  percent=$(echo "$line" | grep -oP '(?<=Bateria: )\d+')

  if [[ "$percent" =~ ^[0-9]+$ ]]; then
    if [ -n "$last_percent" ]; then
      percent_diff=$((last_percent - percent))
      time_diff=$(( ( $(date -d "$timestamp" +%s) - $(date -d "$last_time" +%s) ) / 60 ))

      if [ "$percent_diff" -gt 0 ] && [ "$time_diff" -gt 0 ]; then
        total_minutes=$((total_minutes + time_diff))
        total_carga=$((total_carga + percent_diff))
      fi
    fi
    last_percent=$percent
    last_time="$timestamp"
  fi
done < "$LOG_FILE"

if [ "$total_carga" -gt 0 ]; then
  consumo_medio=$(echo "scale=4; $total_minutes / $total_carga" | bc)
else
  consumo_medio=7.2
fi

if [[ -n "$battery_level" && "$battery_level" =~ ^[0-9]+$ ]]; then
  minutos_restantes=$(echo "$battery_level * $consumo_medio" | bc)
  horas=$(echo "$minutos_restantes/60" | bc)
  minutos=$(echo "$minutos_restantes-($horas*60)" | bc | awk '{print int($1)}')

  notify-send -u normal -i battery-good-symbolic "🔋 Headset G533" "${battery_level}% de bateria — Estimado: ${horas}h ${minutos}min restantes (baseado no seu uso real)"
else
  echo "⚠️ Não foi possível obter o nível da bateria."
fi
