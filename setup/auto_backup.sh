#!/bin/bash

# Caminhos
LOG_DIR="$HOME/.local/share/g533/logs"
BACKUP_DIR="$LOG_DIR/backups"
LOG_FILE="$LOG_DIR/g533_battery_log.txt"

# Data atual
DATE=$(date '+%Y-%m-%d')

# Cria pasta se necessário
mkdir -p "$BACKUP_DIR"

# Copia o log atual para o backup diário
cp "$LOG_FILE" "$BACKUP_DIR/g533_battery_log_$DATE.txt"

echo "✅ Backup diário criado em $BACKUP_DIR/g533_battery_log_$DATE.txt"
