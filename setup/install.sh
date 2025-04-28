#!/bin/bash

# Caminhos
BASE_DIR="$HOME/.local/share/g533"
SCRIPT_DIR="$BASE_DIR/scripts"
SETUP_DIR="$BASE_DIR/setup"
LOG_DIR="$BASE_DIR/logs"
TEMP_DIR="$BASE_DIR/temp"
BACKUP_DIR="$LOG_DIR/backups"
HEADSETCONTROL_REPO="https://github.com/Sapd/HeadsetControl.git"
HEADSETCONTROL_DIR="$HOME/HeadsetControl"
LOGROTATE_CONF="$SETUP_DIR/logrotate_g533.conf"

# Função para instalar pacotes necessários
install_dependencies() {
  echo "📦 Instalando pacotes necessários..."
  sudo apt update
  sudo apt install -y git cmake make g++ libhidapi-dev libhidapi-hidraw0 libhidapi-libusb0 gnuplot libnotify-bin zenity pulseaudio-utils bc logrotate
}

# Função para instalar o headsetcontrol
install_headsetcontrol() {
  if ! command -v headsetcontrol &> /dev/null; then
    echo "🎧 Instalando HeadsetControl..."
    git clone "$HEADSETCONTROL_REPO" "$HEADSETCONTROL_DIR"
    cd "$HEADSETCONTROL_DIR" || exit
    mkdir -p build && cd build
    cmake ..
    make
    sudo make install
    sudo udevadm control --reload
    sudo udevadm trigger
    echo "✅ HeadsetControl instalado com sucesso."
  else
    echo "🎧 HeadsetControl já instalado, pulando..."
  fi
}

# Função para criar pastas
prepare_directories() {
  echo "📂 Criando estrutura de diretórios..."
  mkdir -p "$SCRIPT_DIR" "$SETUP_DIR" "$LOG_DIR" "$TEMP_DIR" "$BACKUP_DIR"
}

# Função para copiar arquivos
copy_files() {
  echo "📄 Copiando scripts..."
  cp ./scripts/*.sh "$SCRIPT_DIR/"
  cp ./setup/*.sh "$SETUP_DIR/"
}

# Função para ajustar permissões
set_permissions() {
  echo "🔧 Ajustando permissões..."
  chmod +x "$SCRIPT_DIR"/*.sh
  chmod +x "$SETUP_DIR"/*.sh
}

# Função para configurar o crontab
configure_cron() {
  echo "⏰ Atualizando crontab..."

  crontab -l > /tmp/current_cron_g533 2>/dev/null

  grep -q "check_g533_battery.sh" /tmp/current_cron_g533 || echo "*/5 * * * * $SCRIPT_DIR/check_g533_battery.sh" >> /tmp/current_cron_g533
  grep -q "tempo_restante_dinamico_g533.sh" /tmp/current_cron_g533 || echo "*/15 * * * * $SCRIPT_DIR/tempo_restante_dinamico_g533.sh" >> /tmp/current_cron_g533
  grep -q "gerar_grafico_g533.sh" /tmp/current_cron_g533 || echo "0 2 * * * $SCRIPT_DIR/gerar_grafico_g533.sh" >> /tmp/current_cron_g533
  grep -q "auto_backup.sh" /tmp/current_cron_g533 || echo "0 0 * * * $SETUP_DIR/auto_backup.sh" >> /tmp/current_cron_g533
  grep -q "purge_old_logs.sh" /tmp/current_cron_g533 || echo "0 3 * * 0 $SETUP_DIR/purge_old_logs.sh" >> /tmp/current_cron_g533

  crontab /tmp/current_cron_g533
  rm /tmp/current_cron_g533
}

# Função para configurar o logrotate
configure_logrotate() {
  echo "♻️ Configurando logrotate para o G533 Monitor..."

  sudo mkdir -p /etc/logrotate.d/

  sudo bash -c "cat > /etc/logrotate.d/g533_monitor" << EOF
$LOG_DIR/g533_battery_log.txt {
    daily
    rotate 14
    missingok
    notifempty
    compress
    delaycompress
    copytruncate
}
EOF

  echo "✅ Logrotate configurado!"
}

# Função principal
main() {
  echo "🚀 Iniciando instalação G533 Monitor Premium..."

  install_dependencies
  install_headsetcontrol
  prepare_directories
  copy_files
  set_permissions
  configure_cron
  configure_logrotate

  echo ""
  echo "✅ Instalação concluída com sucesso!"
  echo "📍 Scripts instalados em: $SCRIPT_DIR"
  echo "📍 Scripts de manutenção em: $SETUP_DIR"
  echo "📍 Logs serão gerados em: $LOG_DIR"
  echo "📍 Arquivos temporários em: $TEMP_DIR"
  echo ""
  echo "⚡ Monitoramento automático ativado via crontab!"
  echo "♻️ Logrotate configurado para rotacionar os logs!"
  echo "🎯 Para ver status: bash $SETUP_DIR/status.sh"
}

# Executa
main
