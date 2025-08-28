#!/bin/bash

# Diretório alvo (se não passar argumento, usa o diretório atual)
DIR="${1:-.}"

# Verifica se o diretório existe
if [ ! -d "$DIR" ]; then
    echo "Diretório não encontrado: $DIR"
    exit 1
fi

# Cria pastas principais se não existirem
mkdir -p "$DIR/Codigos"
mkdir -p "$DIR/Executaveis"
mkdir -p "$DIR/Testes"

# Percorre os arquivos do diretório
for file in "$DIR"/*; do
    if [ -f "$file" ]; then
        case "${file##*.}" in
            c)
                mv "$file" "$DIR/Codigos/"
                ;;
            exe)
                mv "$file" "$DIR/Executaveis/"
                ;;
        esac
    fi
done

echo "Arquivos organizados em $DIR"
