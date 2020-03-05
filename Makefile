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
build: Dockerfile ## Build Docker Image From Dockerfile
	$(DOCKER) build -t $(AUTHOR)/$(PROJECT) .

hello-world: ## Show Hello World From Container
	$(DOCKER) run $(AUTHOR)/$(PROJECT) "Hello World!"

push: ## Push image to Docker repository
	$(DOCKER) push $(AUTHOR)/$(PROJECT)

## ——  Stats  —————————————————————————————————————————————————————————————————
stats: ## Commits by hour for the main author of this project
	$(GIT) log --author="$(AUTHOR)" --date=iso | perl -nalE 'if (/^Date:\s+[\d-]{10}\s(\d{2})/) { say $$1+0 }' | sort | uniq -c|perl -MList::Util=max -nalE '$$h{$$F[1]} = $$F[0]; }{ $$m = max values %h; foreach (0..23) { $$h{$$_} = 0 if not exists $$h{$$_} } foreach (sort {$$a <=> $$b } keys %h) { say sprintf "%02d - %4d %s", $$_, $$h{$$_}, "*"x ($$h{$$_} / $$m * 50); }'