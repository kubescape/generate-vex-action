#!/usr/bin/env bash
set -x

# Install kind and kubectl
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-$(uname)-amd64
chmod +x ./kind
./kind create cluster
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
sudo ./get_helm.sh
# Install Kubescape
helm repo add kubescape https://kubescape.github.io/helm-charts/
helm repo update
helm upgrade --install kubescape kubescape/kubescape-operator -n kubescape --create-namespace --set clusterName="$(kubectl config current-context)" --set capabilities.vexGeneration=enable
# Wait for the pod to be ready
sleep 15
kubectl get pods -n kubescape
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=node-agent -n kubescape --timeout=300s
