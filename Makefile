.PHONY: build test

IMAGE ?= bloom-eval-agent-base:dev

build:
	docker build --tag "$(IMAGE)" .

test: build
	scripts/test-image.sh "$(IMAGE)"
