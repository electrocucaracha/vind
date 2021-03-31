# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2021
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

DOCKER_CMD ?= $(shell which docker 2> /dev/null || which podman 2> /dev/null || echo docker)
IMAGE_VERSION ?= $(shell git describe --abbrev=0 --tags)
IMAGE_NAME=electrocucaracha/vind:$(IMAGE_VERSION)

lint:
	sudo -E $(DOCKER_CMD) run -e RUN_LOCAL=true --rm -e LINTER_RULES_PATH=/ -v $$(pwd):/tmp/lint github/super-linter

.PHONY: build
build:
	sudo -E $(DOCKER_CMD) build -t $(IMAGE_NAME) .
	sudo -E $(DOCKER_CMD) image prune --force
push: build
	docker-squash $(IMAGE_NAME)
	sudo -E $(DOCKER_CMD) push $(IMAGE_NAME)
buildx:
	sudo -E $(DOCKER_CMD) buildx build --platform linux/amd64,linux/arm64 -t $(IMAGE_NAME) --push .
