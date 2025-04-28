#!/bin/bash

# Configurações globais
LOG_DIR="$HOME/.local/share/g533/logs"
TEMP_DIR="$HOME/.local/share/g533/temp"
SCRIPT_DIR="$HOME/.local/share/g533/scripts"

LOG_FILE="$LOG_DIR/g533_battery_log.txt"
LAST_BATTERY_FILE="$TEMP_DIR/g533_last_battery.txt"

FULL_BATTERY_HOURS=12  # Estimativa realista
THRESHOLD_CRITICAL=10  # Crítico
THRESHOLD_LOW=20       # Baixo
THRESHOLD_SHOW=100     # Sempre mostrar
SOUND_PATH="/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga"

mkdir -p "$LOG_DIR" "$TEMP_DIR"
