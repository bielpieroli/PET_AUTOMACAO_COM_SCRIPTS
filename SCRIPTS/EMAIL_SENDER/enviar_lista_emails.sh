#!/bin/bash

CSV_NAME="dados.csv"         # Nome do arquivo CSV com nome,e-mail
PATH_ANEXOS="ANEXOS/"        # Pasta onde estão os arquivos PDF dos certificados
TIPO_ANEXO=".png"            # Tipo do anexo de que se está enviando
MENSAGEM="texto.txt"         # Arquivo em que consta a mensagemm a ser enviada

# Ignora o cabeçalho e lê linha por linha (nome,email)
tail -n +2 "$CSV_NAME" | while IFS=',' read -r nome email; do

    # Formata o nome (ex: "João Gabriel" -> "João_Gabriel")
    nome_formatado=$(echo "$nome" | sed 's/ /_/g')

    # Monta o caminho completo do certificado
    arquivo_certificado="${PATH_ANEXOS}${nome_formatado}${TIPO_ANEXO}"

    # Verifica se o certificado existe
    if [[ -f "$arquivo_certificado" ]]; then
        # Corpo do e-mail
        corpo_email=$(sed "s/{{nome}}/$nome/g" texto.txt) # O sed busca no .txt por {{nome}} e substitui pela variável 'nome'

        # Envia o e-mail COM o certificado em anexo
        echo "$corpo_email" | mutt -s "Título do Email" -e "set from='PET COMPUTAÇÃO <petcomp@icmc.usp.br>'" -a "$arquivo_certificado" -- "$email"

        # Confirmação de envio
        echo "✅ Email enviado para $nome <$email> com anexo"
    else
        # Corpo do e-mail
        corpo_email=$(sed "s/{{nome}}/$nome/g" $MENSAGEM) # O sed busca no .txt por {{nome}} e substitui pela variável 'nome'

        # Envia o e-mail SEM anexo
        echo "$corpo_email" | mutt -s "Título do Email" -e "set from='PET COMPUTAÇÃO <petcomp@icmc.usp.br>'" -- "$email"

        # Confirmação de envio
        echo "⚠️ Email enviado para $nome <$email> SEM anexo (arquivo não encontrado)"
    fi

done