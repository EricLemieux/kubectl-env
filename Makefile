.PHONY: build
build:
	shellcheck  kubectl-env

.PHONY: install
install:
	cp kubectl-env /usr/local/bin/

.PHONY: e2e-test
e2e-test:
	kubectl apply -f test --wait
	kubectl wait --for=condition=Ready pod -l app=example-deployment
	./kubectl-env $$(kubectl get pod -l app=example-deployment -o name)
