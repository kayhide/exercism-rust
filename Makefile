EXERCISMS := $(shell find . -name ".exercism")
EXERCISES := $(EXERCISMS:./%/.exercism=%)
MAKEFILES := $(foreach ex,${EXERCISES},${ex}/Makefile)


init: ${MAKEFILES}
.PHONY: init

%/Makefile:
	@echo "EXERCISE := ${@D}" > $@
	@echo "" >> $@
	@echo "include ../Makefile" >> $@


# Exercise Commands

test:
	cargo test
.PHONY: test

dev:
	find . -name "*.rs" | entr -cdr bash -c "timeout 3 cargo test"
.PHONY: dev
