#!/bin/bash

# Diretório alvo (se não passar argumento, usa o diretório atual)
DIR="${1:-.}"

# Verifica se o diretório existe
if [ ! -d "$DIR" ]; then
    echo "Diretório não encontrado: $DIR"
    exit 1
fi

# Percorre os arquivos do diretório
for file in "$DIR"/*; do
    if [ -f "$file" ]; then
        # Pega a extensão (parte depois do último ponto)
        ext="${file##*.}"
        name="${file##*/}"

        # Se não tiver extensão, coloca em "sem_extensao"
        if [ "$name" = "$ext" ]; then
            ext="sem_extensao"
        fi

        # Cria pasta para a extensão, se não existir
        mkdir -p "$DIR/$ext"

        # Move o arquivo para a pasta correspondente
        mv "$file" "$DIR/$ext/"
    fi
done

echo "Arquivos organizados por extensão em $DIR"
