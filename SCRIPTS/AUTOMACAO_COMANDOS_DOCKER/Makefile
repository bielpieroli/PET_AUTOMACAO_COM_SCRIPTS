# Diretriz para construir a imagem Docker
build:
	@echo "Construindo a imagem Docker..."
	docker build -t imageName .

# Diretriz para colocar o container para iniciar
run:
	@echo "Iniciando container em segundo plano..."

	docker run -d \
		--log-driver local --log-opt max-size=10m \
		--restart unless-stopped \
		--name docker-name \
		dockerName
	@echo "Container iniciado."

# Diretriz para para o container Docker
stop:
	@echo "Parando container..."
	@docker stop docker-name || true
	@docker rm docker-name || true
	@echo "Container parado e removido."

# Diretriz que apaga a imagem Docker criada
clean: stop
	@echo "Removendo imagem..."
	@docker rmi dockerName || true
	@echo "Limpeza concluída."

# Diretriz que engloba todas as diretrizes para restartar
restart:
	make clean
	make build
	make run

.PHONY: build run stop clean restart