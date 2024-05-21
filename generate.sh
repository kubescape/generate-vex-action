#!/usr/bin/env bash
set -x

timeout=300
start_time=$SECONDS
while [[ -z $(kubectl -n kubescape get openvulnerabilityexchangecontainers.spdx.softwarecomposition.kubescape.io) ]]; do
    echo "Waiting for VEX generation..."
    sleep 10
    if [[ $((SECONDS - start_time)) -gt $timeout ]]; then
        echo "Timeout reached. Exiting..."

        # Loop through all pods in the kubescape namespace and print the logs
        for pod in $(kubectl -n kubescape get pods -o jsonpath='{.items[*].metadata.name}'); do
            echo "Logs for $pod:"
            kubectl -n kubescape logs "$pod"
        done

        break
    fi
done

echo "Saving VEX results..."
kubectl -n kubescape get openvulnerabilityexchangecontainer \
    "$(kubectl -n kubescape get openvulnerabilityexchangecontainer -o jsonpath='{.items[0].metadata.name}')" \
    -o jsonpath='{.spec}' > vex.json

echo "Affected:"
jq "." vex.json | grep -c "\"affected\""

echo "Not affected:"
jq "." vex.json | grep -c "\"not_affected\""
