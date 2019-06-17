.PHONY: all
all: docker

.PHONY: docker
docker:
	docker build -t active-iot/docker-proto:latest .