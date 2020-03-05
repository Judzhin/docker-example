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

clear: ## Clear stoped containers
	docker rm -v $(docker ps -aq -f status=exited)

## ——  Git  ———————————————————————————————————————————————————————————————————
lazy-commit: ## Add and fix changes
	$(GIT) add . && $(GIT) commit -am "Lazy Intermedaite commit"

lazy-push: ## Push fix changes
	$(GIT) push

lazy-deploy: lazy-commit lazy-push ## Lazy Command for Commit and Push to repository

## ——  Profiler  —————————————————————————————————————————————————————————————————
log: ## One liner with colors
	$(GIT) log --color --graph --pretty=format:'%Cred[%h] %Cred%ad%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit --date=short

log1:
	$(GIT) log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all

log2:
	$(GIT) log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all

graph: ## One liner with colors
	$(GIT) log --graph --oneline --decorate --all

last: ## One liner with colors
	$(GIT) log -p -1

print: ## Commits by hour for the main author of this project
	$(GIT) lg -p