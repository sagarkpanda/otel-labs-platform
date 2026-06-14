#!/bin/bash

set +e

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

echo "Done."