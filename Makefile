all: lint-spectral lint-openapi


lint-spectral:
	npx @stoplight/spectral-cli lint ./ipfs-pinning-service.yaml
lint-openapi:
	docker run --rm -e RUN_LOCAL=true -e VALIDATE_OPENAPI=true -v $(shell pwd):/tmp/lint github/super-linter:v4
