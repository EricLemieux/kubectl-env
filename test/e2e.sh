#!/usr/bin/env bash

secondary_namespace="my-namespace"

assert_contains() {
  if [[ "${2}" != *"${3}"* ]]; then
    echo "❌ - Unable to locate ${3} in ${2}" >&2
    exit 1
  else
    echo "✔ - ${1}"
  fi
  echo "------------------------------"
}

setup() {
  if [[ ! $(kubectl get ns "${secondary_namespace}") ]]; then
    kubectl create namespace "${secondary_namespace}"
  fi

  kubectl apply -f test --wait
  kubectl apply -f test -n "${secondary_namespace}" --wait
  kubectl wait --for=condition=Ready pod -l app=example-deployment
}

main() {
  setup

  pod=$(kubectl get pod -l app=example-deployment -o name)

  assert_contains "Contains an error message when missing a pod" "$(./kubectl-env 2>&1)" "ERROR: Pod required"
  assert_contains "Finds env values from pod" "$(./kubectl-env "${pod}")" "ABC=abc"

  # Namspace selector
  ns_pod=$(kubectl get pod -l app=example-deployment -o name -n my-namespace)
  assert_contains "Find env values in secondary namespace" "$(./kubectl-env "${ns_pod}" -n "${secondary_namespace}")" "ABC=abc"

  # Container selector
  container_pod=$(kubectl get pod -l app=example-multi-container -o name)
  assert_contains "Finds values in the primary container with no extra specificity" "$(./kubectl-env "${container_pod}")" "ABC=abc"
  assert_contains "Finds values in the primary container with container selector" "$(./kubectl-env "${container_pod}" -c "primary-container")" "ABC=abc"
  assert_contains "Finds values in the secondary container with container selector" "$(./kubectl-env "${container_pod}" -c "secondary-container")" "ABC=aaa"
}

main "${@}"
