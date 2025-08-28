# 📬 Enviador Automático de E-mails com Anexos

![Bash](https://img.shields.io/badge/Bash-Shell%20Script-darkgreen?logo=gnu-bash&logoColor=white)
![mutt](https://img.shields.io/badge/mutt-Terminal%20Mail%20Client-blue?logo=maildotru&logoColor=white)
![msmtp](https://img.shields.io/badge/msmtp-SMTP%20Agent-brightgreen?logo=simpleicons&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu%2FDebian-orange?logo=linux&logoColor=white)

Este projeto permite o envio automático de e-mails personalizados com anexos, utilizando um arquivo `.csv` com os nomes e e-mails dos destinatários.

<br>

## ⚙️ Requisitos

Antes de usar o script, certifique-se de que os seguintes programas estão instalados:

### 📦 Dependências

| Programa     | Função                                 | Instalação                                           |
|--------------|----------------------------------------|------------------------------------------------------|
| `bash`       | Executa os scripts `.sh`               | Já incluso no Linux/macOS                            |
| `mutt`       | Cliente de e-mail via terminal         | `sudo apt install mutt` (Debian/Ubuntu)              |
| `msmtp`      | Envia os e-mails via SMTP              | `sudo apt install msmtp` (Debian/Ubuntu)             |

> ⚠️ O `mutt` exige um agente SMTP (como o `msmtp`) para enviar e-mails de fato.

<br>

## 🧩 Estruturação do repositório

```
.
├── EMAIL_SENDER
│   ├── ANEXOS
│   │   ├── 1.png
│   │   ├── 2.png
│   │   ├── ... .png
│   │   └── Todos os anexos
│   ├── dados.csv
│   ├── enviar_lista_emails.sh
│   ├── setup.sh
│   └── texto.txt
└── README.md
```

<br>

## 🛠️ Configuração do ambiente

### 1. Criar o arquivo CSV com os destinatários

Crie um arquivo `dados.csv` com o seguinte formato:

```csv
nome,email
João Gabriel,joao@exemplo.com
Maria Silva,maria@exemplo.com
```

- A primeira linha é o cabeçalho;
- Os nomes podem conter espaços;
- Os e-mails devem ser válidos;
- O arquivo deve terminar com uma linha em branco (`\n` no final).

<br>

### 2. Colocar os anexos na pasta `ANEXOS/`

Crie a pasta `ANEXOS/` e coloque todos os arquivos anexos nela. No script, defina a constante `TIPO_ANEXO` com a extensão desejada (por exemplo, `.pdf`).

O nome do arquivo deve ser igual ao nome no CSV, substituindo os espaços por underscores (`_`).

**Exemplo:**

Se no CSV consta:

```
João Gabriel
```

O arquivo correspondente deve ser nomeado como:

```
ANEXOS/João_Gabriel.pdf
```

<br>

### 3. Configurar o `msmtp` (`~/.msmtprc`)

Crie o arquivo de configuração:

```bash
nano ~/.msmtprc
```

Exemplo com conta Gmail:

```ini
defaults
auth on
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile ~/.msmtp.log

account gmail
host smtp.gmail.com
port 587
from seuemail@gmail.com
user seuemail@gmail.com
password sua-senha-de-aplicativo

account default : gmail
```

> 🔐 Utilize uma **senha de aplicativo**, criada em [https://myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords). É necessário ativar a verificação em duas etapas (2FA).

Proteja o arquivo:

```bash
chmod 600 ~/.msmtprc
```

<br>

## 🚀 Executando

### 1. Verificar o ambiente

Execute o script de verificação:

```bash
./setup.sh
```

Esse script verifica:
- Se `mutt` e `msmtp` estão instalados;
- Se `dados.csv` existe;
- Se os arquivos da pasta `ANEXOS/` correspondem ao CSV.

> Dê permissão de execução se necessário:

```bash
chmod +x setup.sh
```

<br>

### 2. Enviar os e-mails

Após a verificação:

```bash
./enviar_lista_emails.sh
```

> Pode ser necessário permitir a execução:

```bash
chmod +x enviar_lista_emails.sh
```

<br>

## 💬 Personalização

No script `enviar_lista_emails.sh`, você pode personalizar:

- O **assunto** do e-mail (`-s "Título do Email"`);
- O **formato dos anexos** (`TIPO_ANEXO`);
- O **nome** do arquivo **CSV** (`CSV_NAME`);
- O **path** dos anexos (`PATH_ANEXOS`);
- A mensagem do **corpo do e-mail** (`MENSAGEM`).

Se desejar inserir variáveis no texto, como o nome do destinatário, use `sed` para substituição:

```bash
sed "s/NOME/$nome/g" texto.txt
```

<br>

## ✅ Teste

Recomenda-se testar com seu próprio e-mail antes de enviar a todos:

```bash
echo "Corpo de teste" | mutt -s "Teste de Envio" -a ANEXOS/Seu_Nome.pdf -- voce@seuemail.com
```

<br>

## 📫 Suporte

Em caso de erro, consulte os logs do `msmtp`:

```bash
cat ~/.msmtp.log
```

---