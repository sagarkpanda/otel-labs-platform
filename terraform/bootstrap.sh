#!/bin/bash

set +e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Updating kubeconfig..."

aws eks update-kubeconfig \
  --region ap-south-1 \
  --name otel-labs

echo "Creating argocd namespace..."

kubectl create namespace argocd \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Adding Helm repo..."

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

echo "Installing ArgoCD..."

helm upgrade --install argocd \
  argo/argo-cd \
  -n argocd \
  --set configs.params."server\\.insecure"=true

echo "Creating otel-labs namespace..."

kubectl create namespace otel-labs \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Applying New Relic secret..."

kubectl apply -f "$REPO_ROOT/k8s/otel-collector/nr-secret.yml"

echo "Done."