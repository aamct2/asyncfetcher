BREW := $(shell which brew)
BUNDLER := $(shell which bundler)
DOCKER := $(shell which docker)
GEM := $(shell which gem)
RUBY := $(shell which ruby)
SWIFTLINT := $(shell which swiftlint)

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

# - Dependencies

# Installs the dependencies
dependencies:
ifndef RUBY
	$(error "Couldn't find Ruby installed.")
endif
	@$(MAKE) install-bundler install-homebrew install-swiftlint

# Installs bundler (or installs the gems if already installed)
install-bundler:
ifndef BUNDLER
	$(GEM) install bundler
	bundle install
else
	$(BUNDLER) install
endif

# Installs homebrew (or runs update if already installed)
install-homebrew:
ifndef BREW
	$(RUBY) -e "$($(CURL) -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	$(BREW) update
endif

# Installs SwiftLint (or updates if already installed)
install-swiftlint:
ifndef SWIFTLINT
	$(BREW) install swiftlint
else
	$(BREW) outdated swiftlint || $(BREW) upgrade swiftlint
endif
