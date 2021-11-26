PYTHON_VERSION ?= python3.7
VENV_BIN ?= .venv/bin/
PIP_UPDATE = $(VENV_BIN)pip3 install --upgrade pip
PIP_CMD ?= $(VENV_BIN)pip3 install docker-compose flake8

PACKAGE ?= jura_crdppf

.PHONY: help
help:
	@echo  "Usage: make <target>"
	@echo
	@echo  "Main targets:"
	@echo
	@echo  "- build			Build and configure the project"
	@echo  "- serve			Serve the composition"
	@echo  "- stop			Stop the composition"
	@echo  "- lint			Run Flake8 checker on the Python code"
	@echo  "- cleanall		Remove all the build artefacts"

.PHONY: build
build: .venv/install-timestamp
	$(VENV_BIN)/docker-compose build

.venv/timestamp:
	python3 -m virtualenv --python=$(PYTHON_VERSION) .venv
	touch $@

.venv/install-timestamp: .venv/timestamp
	$(PIP_UPDATE)
	$(PIP_CMD)
	touch $@

.PHONY: serve
serve: build 
	$(VENV_BIN)/docker-compose up --remove-orphans -d

.PHONY: stop
stop:
	$(VENV_BIN)/docker-compose down --remove-orphans

.PHONY: lint
lint: .venv/install-timestamp
	$(VENV_BIN)flake8 $(PACKAGE)

.PHONY: cleanall
cleanall: stop
	rm -rf .venv

write_ci_docker_env:
	echo "COMPOSE_PROJECT_NAME=ci_oereb" >> .env
	echo "EXTERNAL_PORT=6543" >> .env
	echo "OEREB_ROUTE_PREFIX=\$${COMPOSE_PROJECT_NAME}" >> .env
