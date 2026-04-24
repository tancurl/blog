BIN = docker

all:
	$(BIN) run \
		-u $(shell id -u):$(shell id -g) \
		-v $(shell pwd):/antora:Z \
		--rm \
		-t antora/antora antora-playbook.yml
