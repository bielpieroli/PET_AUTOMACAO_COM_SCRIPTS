#!/bin/bash

CSV_NAME="dados.csv"
PATH_ANEXOS="ANEXOS/"

echo -e "\n========================================"
echo "📦 Verificando dependências do sistema"
echo "========================================"

# 0. Verifica se o 'msmtp' está instalado (utilizado para enviar os emails itself)
echo -e "\nVerificando se o 'msmtp' está instalado..."
if ! command -v msmtp &> /dev/null; then
    echo -e "❌ O comando 'msmtp' não foi encontrado."
    echo -e "👉 Instale com o seguinte comando, dependendo do seu sistema:"
    echo -e "   Ubuntu/Debian: sudo apt install msmtp"
    echo -e "   Fedora: sudo dnf install msmtp"
    echo -e "   Arch: sudo pacman -S msmtp"
    echo -e "   macOS (brew): brew install msmtp"
    echo -e "\n📝 Após instalar, você deve configurar o arquivo ~/.msmtprc com as credenciais SMTP."
    echo -e "  O arquivo ~/.msmtprc deve ter o seguinte conteúdo:\n
            account petcomp
            host smtp.gmail.com
            port 587
            from petcomp@icmc.usp.br
            user petcomp@icmc.usp.br
            password **************** (PASSWORD ESTÁ NO ARQUIVO SENHAS APPS_GMAIL)
            tls on
            auth on
            tls_trust_file /etc/ssl/certs/ca-certificates.crt
            logfile ~/.msmtp.log
            account default : petcomp"
    exit 1
else
    echo -e "✅ 'msmtp' instalado com sucesso."
fi

# 1. Verifica se o 'mutt' está instalado (utilizado para enviar emails com anexo)
echo -e "\nVerificando se o 'mutt' está instalado..."
if ! command -v mutt &> /dev/null; then
    echo -e "❌ O comando 'mutt' não foi encontrado."
    echo -e "👉 Instale com o seguinte comando, dependendo do seu sistema:"
    echo -e "   Ubuntu/Debian: sudo apt install mutt"
    echo -e "   Fedora: sudo dnf install mutt"
    echo -e "   Arch: sudo pacman -S mutt"
    echo -e "   macOS: brew install mutt"
    exit 1
else
    echo -e "✅ 'mutt' instalado com sucesso."
fi

echo -e "\n========================================"
echo "📰 Verificando a existência dos arquivos"
echo "========================================"

# 2. Verifica se o arquivo CSV existe
echo -e "\nVerificando se o arquivo '$CSV_NAME' está presente..."
if [[ ! -f "$CSV_NAME" ]]; then
    echo -e "❌ Arquivo '$CSV_NAME' não encontrado no diretório atual."
    echo -e "👉 Crie um arquivo chamado '$CSV_NAME' com o seguinte formato:"
    echo -e "   nome,email"
    echo -e "   João Gabriel,joaogabriel@exemplo.com"
    echo -e "   Lórena,lorena@exemplo.com"
    exit 1
else
    echo -e "✅ Arquivo CSV encontrado."
fi

# 2. Verifica se o arquivo CSV existe
echo -e "\nVerificando se o arquivo '$CSV_NAME' está presente..."
if [[ ! -f "$CSV_NAME" ]]; then
    echo -e "❌ Arquivo '$CSV_NAME' não encontrado no diretório atual."
    echo -e "👉 Crie um arquivo chamado '$CSV_NAME' com o seguinte formato:"
    echo -e "   nome,email"
    echo -e "   João Gabriel,joaogabriel@exemplo.com"
    echo -e "   Lórena,lorena@exemplo.com"
    exit 1
else
    echo -e "✅ Arquivo CSV encontrado."
fi

# 3. Verifica se existe pelo menos um certificado PDF correspondente
echo -e "\n📑 Verificando certificados (PDFs) no diretório '$PATH_ANEXOS'..."

ANEXOS_ENCONTRADOS=false
while IFS=',' read -r nome email; do
    [[ "$nome" == "nome" ]] && continue  # ignora o cabeçalho
    nome_formatado=$(echo "$nome" | sed 's/ /_/g')
    arquivo_certificado="${PATH_ANEXOS}${nome_formatado}.pdf"

    if [[ -f "$arquivo_certificado" ]]; then
        ANEXOS_ENCONTRADOS=true
        echo "✔️  Anexo encontrado: $arquivo_certificado"
    else
        echo "⚠️  Anexo faltando para: $nome"
    fi
done < "$CSV_NAME"

# Verifica se pelo menos um certificado foi encontrado
if ! $ANEXOS_ENCONTRADOS; then
    echo -e "❌ Nenhum anexo encontrado em '$PATH_ANEXOS'."
    echo -e "👉 Verifique se os arquivos estão na pasta correta e nomeados corretamente."
    exit 1
fi

# 4. Sugestão de teste para envio manual
echo -e "\n📨 Sugestão de teste:"
echo -e "Para testar o envio de e-mails, use um exemplo manual como:"
echo -e "echo 'Olá!' | mutt -s 'Teste' -a ${PATH_ANEXOS}seu_arquivo.pdf -- seuemail@exemplo.com"

# 5. Finalização
echo -e "\n========================================"
echo "✅ Setup concluído com sucesso!"
echo "📁 Agora você pode rodar seu script de envio de e-mails."
echo "========================================"