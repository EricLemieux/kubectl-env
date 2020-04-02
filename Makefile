.PHONY: build
build:
	shellcheck  kubectl-env

.PHONY: install
install:
	cp kubectl-env /usr/local/bin/

.PHONY: e2e-test
e2e-test:
	kubectl apply -f test --wait
	./kubectl-env example-deployment