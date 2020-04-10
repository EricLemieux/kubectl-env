.PHONY: build
build:
	shellcheck  kubectl-env

.PHONY: install
install:
	cp kubectl-env /usr/local/bin/

.PHONY: e2e-test
e2e-test:
	./test/e2e.sh
