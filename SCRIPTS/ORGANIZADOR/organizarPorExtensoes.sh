#!/bin/bash

DIR="${1:-.}"

if [ ! -d "$DIR" ]; then
    echo "Diretório não encontrado: $DIR"
    exit 1
fi

for file in "$DIR"/*; do
    if [ -f "$file" ]; then

        ext="${file##*.}"
        name="${file##*/}"

        if [ "$name" = "$ext" ]; then
            ext="sem_extensao"
        fi

        ext="${ext,,}"
        
        mkdir -p "$DIR/$ext"

        mv "$file" "$DIR/$ext/"
    fi
done

echo "Arquivos organizados por extensão em $DIR"
