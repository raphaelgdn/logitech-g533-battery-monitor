#!/bin/bash

# Caminhos
BACKUP_DIR="$HOME/.local/share/g533/logs/backups"

# Deleta backups mais antigos que 30 dias
find "$BACKUP_DIR" -type f -name "*.txt" -mtime +30 -exec rm {} \;

echo "🧹 Backups antigos removidos (mais de 30 dias)."
