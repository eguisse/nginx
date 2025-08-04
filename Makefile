# Makefile for project eguisse/toolbox

SHELL := /bin/bash
# grep the version from the mix file
CURRENT_DIR := $(CURDIR)
ifeq ($(strip $(PROJECT_DIR)), )
PROJECT_DIR := $(CURRENT_DIR)
endif
export PROJECT_DIR
export CURRENT_DIR
export VERSION

# HELP
# This will output the help for each task
.PHONY: help clean build-app build run print-env

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


print-env:  ## print environment variables
	echo "PROJECT_DIR: $(PROJECT_DIR)"
	echo "CURRENT_DIR: $(CURRENT_DIR)"
	echo "VERSION: $(VERSION)"
	echo "CURDIR: $(CURDIR)"

build:  ## Build the docker image
	@echo "start build"
	docker buildx build -t "nginx:snapshot" \
		-f "$(PROJECT_DIR)/Dockerfile" "$(PROJECT_DIR)"

run:  ## Run the docker image on localhost
	@echo "start run"
	if [[ ! -d "$(PROJECT_DIR)/.env" ]] ; then touch "$(PROJECT_DIR)/.env" ; fi
	docker run -it --rm --name nginx --env-file .env  "nginx:snapshot"

server:  ## Run the server in the background
	@echo "start server"
	if [[ ! -d "$(PROJECT_DIR)/.env" ]] ; then touch "$(PROJECT_DIR)/.env" ; fi
	mkdir -p $(PROJECT_DIR)/data
	docker run -it --rm --name activemq --env-file .env -p 61616:61616 -p 8161:8161 "activemq:snapshot"
