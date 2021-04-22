### Make config

.ONESHELL:
SHELL = bash
.SHELLFLAGS = -eu -c
.PHONY: cga-proxy-custom-data cga-proxy-marketplace create-az-map git-clean lint

### Actions

cga-proxy-custom-data:
	./helpers/create-custom-data-base64.sh ./helpers/cga-proxy-custom-data.sh ./templates/cga-proxy/mainTemplate.json

cga-proxy-marketplace:
	./helpers/create-marketplace-zip.sh ./templates/cga-proxy

create-az-map:
	./helpers/create-az-map.sh

git-clean:
	@if git diff --exit-code; then
		echo "Git is clean"
	else
		echo "Git changes detected! Check and commit changes"
		exit 1
	fi

lint:
	act -j linter --env-file <(echo "RUN_LOCAL=true")
