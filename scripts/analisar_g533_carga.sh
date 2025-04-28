#!/bin/bash
source "$HOME/.local/share/g533/scripts/env.sh"

if [ ! -f "$LOG_FILE" ]; then
  echo "❌ Arquivo de log não encontrado."
  exit 1
fi

echo "🔋 Analisando histórico de carga do G533..."
echo ""

last_percent=""
last_time=""
total_minutes=0
total_carga=0
ciclos=0

while IFS= read -r line; do
  timestamp=$(echo "$line" | awk '{print $1" "$2}')
  percent=$(echo "$line" | grep -oP '(?<=Bateria: )\d+')

  if [[ "$percent" =~ ^[0-9]+$ ]]; then
    if [ -n "$last_percent" ]; then
      percent_diff=$((percent - last_percent))
      time_diff=$(( ( $(date -d "$timestamp" +%s) - $(date -d "$last_time" +%s) ) / 60 ))

      if [ "$percent_diff" -gt 0 ] && [ "$time_diff" -ge 0 ]; then
        total_minutes=$((total_minutes + time_diff))
        total_carga=$((total_carga + percent_diff))
        ciclos=$((ciclos + 1))

        echo "🕰️ De $last_time ($last_percent%) até $timestamp ($percent%) ➔ +$percent_diff% em $time_diff min"
      fi
    fi
    last_percent=$percent
    last_time="$timestamp"
  fi
done < "$LOG_FILE"

echo ""
echo "📈 Resultado da Análise:"
if [ "$total_carga" -gt 0 ]; then
  media=$(echo "scale=2; $total_minutes / $total_carga" | bc)
  tempo_estimado=$(echo "scale=2; $media * 100" | bc)
  tempo_estimado_horas=$(echo "scale=2; $tempo_estimado/60" | bc)

  echo "⏳ Velocidade média de carga: 1% a cada ~$media minutos"
  echo "🕰️ Estimativa para carga completa: ~$tempo_estimado minutos (~$tempo_estimado_horas horas)"
  echo "🔄 Ciclos detectados: $ciclos"
else
  echo "⚠️ Nenhum aumento de carga detectado ainda."
fi
echo ""
