#!/usr/bin/env bash
set -x

# Wait the nodeAgent.config.updatePeriod used when installing the Kubescape helm chart.
# This ensures that the VEX documents are updated with the latest usage data.
sleep 60

# Now attempt to retrieve the VEX documents
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
mkdir -p out

# List available VEX documents
vex_docs=$(kubectl get openvulnerabilityexchangecontainer -n kubescape -o jsonpath='{.items[*].metadata.name}')

# Iterate over the VEX documents and save them
for doc in $vex_docs; do
    # Get the full VEX document object
    vex_object=$(kubectl -n kubescape get openvulnerabilityexchangecontainer "$doc" -o json)

    # Check the labels to see if this VEX is for a workload in the TESTS_NAMESPACE
    
    workload_ns=$(jq -r ".metadata.labels[\"kubescape.io/workload-namespace\"]" <<< "$vex_object")
    if [[ $workload_ns != "$TESTS_NAMESPACE" ]]; then
        echo "Skipping VEX document $doc as it is not for the TESTS_NAMESPACE"
        continue
    fi

    # Get the image name
    image=$(jq -r ".metadata.labels[\"kubescape.io/image-id\"]" <<< "$vex_object")

    # # Save the VEX document (the .spec portion) to a file
    jq ".spec" <<< "$vex_object" > out/"$image".json

    echo "Affected:"
    jq "." out/"$image".json | grep -c "\"affected\""

    echo "Not affected:"
    jq "." out/"$image".json | grep -c "\"not_affected\""
done

# Check if there are any VEX documents saved
if [[ -z $(ls out) ]]; then
    echo "No VEX documents saved. Exiting..."
    exit 1
fi
