#!/bin/bash

# Caminhos
BASE_DIR="$HOME/.local/share/g533"
SCRIPT_DIR="$BASE_DIR/scripts"
SETUP_DIR="$BASE_DIR/setup"
LOG_DIR="$BASE_DIR/logs"
TEMP_DIR="$BASE_DIR/temp"
HEADSETCONTROL_DIR="$HOME/HeadsetControl"

# Função para remover o headsetcontrol
remove_headsetcontrol() {
  echo "🎧 Removendo HeadsetControl..."

  if command -v headsetcontrol &> /dev/null; then
    sudo rm -f /usr/local/bin/headsetcontrol
    sudo rm -f /usr/local/lib/udev/rules.d/70-headsets.rules
    sudo udevadm control --reload
    sudo udevadm trigger
    echo "✅ HeadsetControl removido."
  else
    echo "⚡ HeadsetControl não estava instalado ou já foi removido."
  fi

  if [ -d "$HEADSETCONTROL_DIR" ]; then
    rm -rf "$HEADSETCONTROL_DIR"
    echo "🗑️ Diretório clonado do HeadsetControl removido."
  fi
}

# Função para limpar crontab
remove_cron() {
  echo "⏰ Limpando crontab..."

  crontab -l > /tmp/current_cron_g533 2>/dev/null

  grep -v "check_g533_battery.sh" /tmp/current_cron_g533 | \
  grep -v "tempo_restante_dinamico_g533.sh" | \
  grep -v "gerar_grafico_g533.sh" > /tmp/cleaned_cron_g533

  crontab /tmp/cleaned_cron_g533
  rm /tmp/current_cron_g533 /tmp/cleaned_cron_g533

  echo "✅ Crontab limpo."
}

# Função para remover pastas e arquivos
remove_directories() {
  echo "🗑️ Removendo diretórios de dados..."

  if [ -d "$BASE_DIR" ]; then
    rm -rf "$BASE_DIR"
    echo "✅ Diretório $BASE_DIR removido."
  else
    echo "⚡ Diretório $BASE_DIR não encontrado, nada para remover."
  fi
}

# Função principal
main() {
  echo "🚀 Iniciando desinstalação do G533 Monitor Premium..."

  remove_cron
  remove_headsetcontrol
  remove_directories

  echo ""
  echo "✅ Desinstalação concluída com sucesso!"
  echo "🎯 Sistema limpo!"
}

# Executa
main
