# Diretórios
SETUP_DIR = $(HOME)/.local/share/g533/setup
SCRIPT_DIR = $(HOME)/.local/share/g533/scripts

# Comandos
install:
	@echo "🚀 Instalando G533 Monitor Premium..."
	bash $(SETUP_DIR)/install.sh

uninstall:
	@echo "🛡️ Desinstalando G533 Monitor Premium..."
	bash $(SETUP_DIR)/uninstall.sh

update:
	@echo "🔄 Atualizando G533 Monitor Premium..."
	bash $(SETUP_DIR)/update.sh

status:
	@echo "🔋 Exibindo Status do G533 Monitor Premium..."
	bash $(SETUP_DIR)/status.sh

backup:
	@echo "📦 Fazendo backup manual dos logs..."
	bash $(SETUP_DIR)/auto_backup.sh

cleanlogs:
	@echo "🧹 Limpando backups antigos..."
	bash $(SETUP_DIR)/purge_old_logs.sh

graph:
	@echo "📈 Gerando gráfico de bateria..."
	bash $(SCRIPT_DIR)/gerar_grafico_g533.sh

help:
	@echo ""
	@echo "G533 Monitor Premium - Comandos disponíveis:"
	@echo ""
	@echo "  make install     ➔ Instalar tudo (dependências, scripts, headsetcontrol)"
	@echo "  make uninstall   ➔ Desinstalar tudo"
	@echo "  make update      ➔ Atualizar scripts e headsetcontrol"
	@echo "  make status      ➔ Mostrar status da bateria e últimos eventos"
	@echo "  make backup      ➔ Fazer backup dos logs manualmente"
	@echo "  make cleanlogs   ➔ Limpar backups antigos de logs"
	@echo "  make graph       ➔ Gerar gráfico de bateria agora"
	@echo "  make help        ➔ Mostrar esta ajuda"
	@echo ""
