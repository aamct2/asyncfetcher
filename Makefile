DOCKER := $(shell which docker)

repo_name := asyncfetcher

# - Docker

# Builds a docker image with the package and starts the container
build-docker:
	$(DOCKER) build -t $(repo_name) .
	$(DOCKER) run -it -d -P $(repo_name)
.PHONY: build-docker

test-docker:
	$(DOCKER) run -t $(repo_name) swift test --package-path /root
.PHONY: test-docker

build-test-docker:
	$(MAKE) build-docker
	$(MAKE) test-docker
.PHONY: build-test-docker
