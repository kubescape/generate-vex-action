#!/usr/bin/env bash
set -x

helm install "$HELM_CHART_PATH" --wait --timeout 300s --generate-name -n "$TESTS_NAMESPACE" --create-namespace

if [[ -n "$READY_CONDITION" ]]; then
    $READY_CONDITION
fi
