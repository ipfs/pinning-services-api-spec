
lint-openapi:
	docker run --rm -e RUN_LOCAL=true -e VALIDATE_OPENAPI=true -v $(shell pwd):/tmp/lint github/super-linter:v3
