#!/usr/bin/env bash

helm install "$HELM_CHART_PATH" --wait --timeout "$INSTALL_TIMEOUT" --generate-name -n "$TESTS_NAMESPACE" --create-namespace

if [[ -n "$READY_CONDITION" ]]; then
    $READY_CONDITION
fi
