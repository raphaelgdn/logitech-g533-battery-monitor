#!/bin/bash
source "$HOME/.local/share/g533/scripts/env.sh"

TEMP_DATA="$TEMP_DIR/battery_data.dat"
OUTPUT_PNG="$LOG_DIR/g533_battery_graph.png"

mkdir -p "$TEMP_DIR"

if [ ! -f "$LOG_FILE" ]; then
  echo "❌ Arquivo de log não encontrado."
  exit 1
fi

echo "# Time Battery" > "$TEMP_DATA"
grep "Bateria:" "$LOG_FILE" | awk -F ' - |: |%' '{print $2, $3}' >> "$TEMP_DATA"

gnuplot << EOF
set terminal png size 1200,600
set output "$OUTPUT_PNG"
set title "Histórico de Bateria - Logitech G533"
set xdata time
set timefmt "%H:%M"
set format x "%H:%M"
set xlabel "Hora"
set ylabel "Bateria (%)"
set grid
set yrange [0:100]
plot "$TEMP_DATA" using 1:2 with linespoints title "Bateria (%)" lw 2 pt 7
EOF

echo "✅ Gráfico gerado em: $OUTPUT_PNG"
