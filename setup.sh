#!/usr/bin/env bash
set -x

# Install Kubescape
helm repo add kubescape https://kubescape.github.io/helm-charts/
helm repo update
helm upgrade --install kubescape kubescape/kubescape-operator -n kubescape --create-namespace \
  --set clusterName="$(kubectl config current-context)" \
  --set capabilities.vexGeneration=enable \
  --set nodeAgent.config.learningPeriod=1m \
  --set nodeAgent.config.updatePeriod=1m \
  --set logger.level=debug \
  --wait
# Wait for the pods to be ready
sleep 5
kubectl -n kubescape wait --for=condition=ready pod -l app.kubernetes.io/name=node-agent --timeout=300s
kubectl -n kubescape wait --for=condition=ready pod -l app.kubernetes.io/name=storage --timeout=300s
echo "Kubescape is ready"
