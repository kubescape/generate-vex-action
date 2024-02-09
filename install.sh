#!/usr/bin/env bash
set -x

kubectl apply -f "$DEPLOYMENT_FILE"
$READY_CONDITION
