TARGET=prometheus_bot

export BASE_CONFIG_PATH = $(if $(DOCKER_HOST),$(REMOTE_CONFIG_PATH),$(LOCAL_CONFIG_PATH))

all: main.go
	go build -o $(TARGET)
test: all
	prove -v
clean:
	go clean
	rm -f $(TARGET)
	rm -f bot.log
sync:
	docker-machine scp -d -r ./config.yaml $(SSH_USER)@$(MACHINE_NAME):$(REMOTE_CONFIG_PATH)
up:
	$(if $(DOCKER_HOST), make sync,)
	docker-compose -f docker-compose.yml up -d --build --remove-orphans