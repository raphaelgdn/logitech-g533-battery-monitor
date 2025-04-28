#!/bin/bash

# Caminhos
BASE_DIR="$HOME/.local/share/g533"
SCRIPT_DIR="$BASE_DIR/scripts"
SETUP_DIR="$BASE_DIR/setup"
LOG_DIR="$BASE_DIR/logs"
TEMP_DIR="$BASE_DIR/temp"

LOG_FILE="$LOG_DIR/g533_battery_log.txt"
LAST_BATTERY_FILE="$TEMP_DIR/g533_last_battery.txt"

# Fonte de ambiente
source "$SCRIPT_DIR/env.sh" 2>/dev/null || true

# Função para mostrar status da bateria atual
show_current_battery() {
  echo "🔋 Status atual da bateria do G533:"
  battery_level=$(headsetcontrol -b 2>/dev/null | grep "Level:" | awk '{print $2}' | sed 's/%//')

  if [[ -n "$battery_level" && "$battery_level" =~ ^[0-9]+$ ]]; then
    echo "   ➔ Bateria atual: $battery_level%"

    # Estimar tempo baseado na vida útil total (configurada)
    battery_float=$(echo "$battery_level/100" | bc -l)
    hours_left=$(echo "$battery_float * $FULL_BATTERY_HOURS" | bc -l)
    hours=$(echo "$hours_left" | awk -F. '{print $1}')
    minutes=$(echo "0.${hours_left#*.} * 60" | bc -l | awk -F. '{print $1}')
    echo "   ➔ Estimativa de duração: ${hours}h ${minutes}min restantes"
  else
    echo "⚠️  Não foi possível obter o nível da bateria."
  fi
}

# Função para mostrar os últimos eventos do log
show_last_logs() {
  echo ""
  echo "📜 Últimos eventos registrados:"
  if [ -f "$LOG_FILE" ]; then
    tail -n 5 "$LOG_FILE" | tac
  else
    echo "⚠️  Log de bateria não encontrado."
  fi
}

# Função principal
main() {
  echo "🚀 Exibindo Status do G533 Monitor Premium"
  echo "-------------------------------------------"
  show_current_battery
  show_last_logs
  echo "-------------------------------------------"
}

# Executa
main
