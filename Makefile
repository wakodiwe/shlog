.PHONY: all envrc format lint

envrc:
	@sh scripts/envrc.sh

format:
	@sh scripts/shfmt.sh

lint:
	@sh scripts/shellcheck.sh

all: lint format envrc
