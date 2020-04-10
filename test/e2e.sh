#!/usr/bin/env bash

assert_contains() {
  if [[ "${1}" != *"${2}"* ]]; then
    echo "Unable to locate ${2} in ${1}" >&2
    exit 1
  fi
}

main() {
  pod=$(kubectl get pod -l app=example-deployment -o name)

  assert_contains "$(./kubectl-env 2>&1)" "ERROR: Pod required"
  assert_contains "$(./kubectl-env "${pod}")" "ABC=abc"
}

main "${@}"
