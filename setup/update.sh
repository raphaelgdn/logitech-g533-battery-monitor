#!/bin/bash

# Caminhos
BASE_DIR="$HOME/.local/share/g533"
SCRIPT_DIR="$BASE_DIR/scripts"
SETUP_DIR="$BASE_DIR/setup"

# Função para atualizar HeadsetControl
update_headsetcontrol() {
  echo "🎧 Atualizando HeadsetControl..."

  if [ -d "$HOME/HeadsetControl" ]; then
    cd "$HOME/HeadsetControl" || exit
    git pull origin master
    mkdir -p build && cd build
    cmake ..
    make
    sudo make install
    sudo udevadm control --reload
    sudo udevadm trigger
    echo "✅ HeadsetControl atualizado com sucesso."
  else
    echo "⚠️ Repositório HeadsetControl não encontrado no sistema."
    echo "🔎 Execute 'install.sh' para instalar primeiro."
  fi
}

# Função para atualizar scripts locais
update_scripts() {
  echo "📄 Atualizando scripts G533 Monitor..."

  if [ -d "./scripts" ]; then
    cp ./scripts/*.sh "$SCRIPT_DIR/"
    chmod +x "$SCRIPT_DIR"/*.sh
    echo "✅ Scripts atualizados em: $SCRIPT_DIR"
  else
    echo "⚠️ Pasta ./scripts não encontrada. Atualização abortada."
  fi

  if [ -d "./setup" ]; then
    cp ./setup/*.sh "$SETUP_DIR/"
    chmod +x "$SETUP_DIR"/*.sh
    echo "✅ Scripts de setup atualizados em: $SETUP_DIR"
  else
    echo "⚠️ Pasta ./setup não encontrada. Atualização abortada."
  fi
}

# Função principal
main() {
  echo "🚀 Iniciando atualização do G533 Monitor Premium..."

  update_headsetcontrol
  update_scripts

  echo ""
  echo "✅ Atualização concluída!"
  echo "🎯 Sistema no estado mais recente!"
}

# Executa
main
