### Make config

.ONESHELL:
SHELL = /bin/bash
.SHELLFLAGS = -eu -c
.PHONY: lint

### Actions

lint:
	act -j linter --env-file <(echo "RUN_LOCAL=true")
