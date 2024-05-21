#!/usr/bin/env bash
set -x

# Get the pod name and container port of the test application
POD_NAME=$(kubectl get pods -l "app.kubernetes.io/name=hello-world" -o jsonpath="{.items[0].metadata.name}")
CONTAINER_PORT=$(kubectl get pod "$POD_NAME" -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
# Expose the test app on localhost
kubectl port-forward "$POD_NAME" 8080:"$CONTAINER_PORT" &
sleep 5
# Test the application by sending a request to it a number of times
for _ in {1..10}; do
    # Prints just the status code
    curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8080
    echo
done
# Stop the port-forwarding
kill %1
