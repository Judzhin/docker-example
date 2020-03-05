# Setup ————————————————————————————————————————————————————————————————————————
AUTHOR = judzhin
PROJECT = cowsay
GIT = git
DOCKER = docker

.DEFAULT_GOAL = help
#.PHONY = # Not needed for now

## ——  The Makefile  ——————————————————————————————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

wait: ## Sleep 5 seconds
	sleep 5

## ——  Docker  ————————————————————————————————————————————————————————————————
bash: ## Enter to container
	$(DOCKER) run -it --name $(PROJECT) --hostname $(PROJECT) ubuntu:bionic bash

commit: ## Fix changes what we do
	$(DOCKER) commit $(PROJECT) $(AUTHOR)/$(PROJECT)

build: Dockerfile ## Build Docker Image From Dockerfile
	$(DOCKER) build -t $(AUTHOR)/$(PROJECT) .

hello-world: ## Show Hello World From Container
	$(DOCKER) run $(AUTHOR)/$(PROJECT) "Hello World!"

push: ## Push image to Docker repository
	$(DOCKER) push $(AUTHOR)/$(PROJECT)

deploy: commit build push ## Lazy command for build and pushing to docker hub

## ——  Git  ———————————————————————————————————————————————————————————————————
lazy-commit:
	$(GIT) add . && $(GIT) commit -am "Lazy Intermedaite commit"

lazy-push:
	$(GIT) push

lazy-deploy: lazy-commit lazy-push

## ——  Stats  —————————————————————————————————————————————————————————————————
stats: ## Commits by hour for the main author of this project
	$(GIT) log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit