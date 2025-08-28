#!/bin/bash

# Verifica se o Python 3 está instalado
echo -e "\n========================================"
echo "🐍 Verificando se Python está instalado"
echo "========================================"
if ! command -v python3 &> /dev/null; then
    echo -e "❌ Python3 não encontrado. Por favor instale manualmente:"
    echo -e "  Ubuntu/Debian: sudo apt install python3 python3-venv"
    echo -e "  Fedora: sudo dnf install python3"
    echo -e "  Arch: sudo pacman -S python"
    echo -e "  macOS: brew install python"
    echo -e "\nDepois de instalar, execute o script novamente."
    exit 1
else
    echo "✅ Python instalado"
fi

# Configuração do ambiente
echo -e "\n========================================"
echo "💻 Configurando o ambiente virtual"
echo "========================================"
echo "Criando ambiente virtual..."
if ! python3 -m venv .venv; then
    echo "❌ Erro ao criar .venv."
    exit 1
fi

echo "Ativando .venv..."
if ! . .venv/bin/activate; then
    echo "❌ Erro ao ativar .venv."
    exit 1
fi

echo "Instalando dependências... (isso pode levar alguns segundos)"
if ! pip install -r requirements.txt > /dev/null 2>&1; then
    echo "❌ Falha ao instalar dependências."
    exit 1
fi
