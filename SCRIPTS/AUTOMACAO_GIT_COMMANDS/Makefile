CONFIGS_DIR = CONFIGS

MESSAGE_FILE = $(CONFIGS_DIR)/mensagem.cfg
MESSAGE = $(shell cat $(MESSAGE_FILE))

EMAIL_FILE = $(CONFIGS_DIR)/email.cfg
EMAIL = $(shell cat $(EMAIL_FILE))

NOME_FILE = $(CONFIGS_DIR)/nome.cfg
NOME = $(shell cat $(NOME_FILE))

BRANCH_FILE = $(CONFIGS_DIR)/branch.cfg
BRANCH = $(shell cat $(BRANCH_FILE))

# Diretriz comandando o commit no Github
commit:
	git add .
	git config --global user.email "$(EMAIL)"
	git config --global user.name "$(NOME)"
	git commit -m "$(MESSAGE)"
	git push origin $(BRANCH)

# Diretriz para trocar a mensagem do commit
mensagem:
	@read -p "Qual a mensagem do commit? " mensagem; \
	echo $$mensagem >$(MESSAGE_FILE); \

# Diretriz para trocar a branch
branch:
	@read -p "Qual a branch? " branch; \
	echo $$branch >$(BRANCH_FILE); \

# Diretriz para criar uma nova branch
criarBranch:
	@read -p "Qual o nome da branch a ser criada? " branchName; \
	git checkout -b $$branchName
