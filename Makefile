PREFIX ?= $(HOME)/.local
DEST   := $(PREFIX)/bin/shlog

.PHONY: install uninstall check

install: uninstall
	@mkdir -p $(dir $(DEST))
	@cp shlog $(DEST)
	@chmod +x $(DEST)
	@printf "Installed to %s\n" "$(DEST)"

uninstall:
	@rm -f $(DEST)
	@printf "Removed %s\n" "$(DEST)"

test:
	cd tests && ./test_shlog.sh

check:
	@shellcheck shlog
