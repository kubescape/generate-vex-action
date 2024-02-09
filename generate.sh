#!/usr/bin/env bash
set -x

kubectl -n kubescape get openvulnerabilityexchangecontainer \
    "$(kubectl -n kubescape get openvulnerabilityexchangecontainer -o jsonpath='{.items[0].metadata.name}')" \
    -o jsonpath='{.spec}' > vex.json
