#!/bin/bash

set +e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo
echo -e "${BLUE}${BOLD}==================================================${NC}"
echo -e "${BLUE}${BOLD}          APPLYING BOOTSTRAP SCRIPT              ${NC}"
echo -e "${BLUE}${BOLD}==================================================${NC}"
echo

echo -e "${BLUE}${BOLD}==> Updating kubeconfig...${NC}"
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name otel-labs

echo -e "${GREEN}✓ Kubeconfig updated${NC}"
echo

echo -e "${BLUE}${BOLD}==> Creating ArgoCD namespace...${NC}"
kubectl create namespace argocd \
  --dry-run=client -o yaml | kubectl apply -f -

echo -e "${GREEN}✓ ArgoCD namespace ready${NC}"
echo

echo -e "${BLUE}${BOLD}==> Adding Helm repositories...${NC}"

echo -e "${YELLOW}1. Adding Argo Helm repository...${NC}"
helm repo add argo https://argoproj.github.io/argo-helm

echo -e "${YELLOW}2. Adding Kyverno Helm repository...${NC}"
helm repo add kyverno https://kyverno.github.io/kyverno/

echo -e "${YELLOW}3. Adding Falco Helm repository...${NC}"
helm repo add falcosecurity https://falcosecurity.github.io/charts

echo -e "${YELLOW}Updating Helm repositories...${NC}"
helm repo update

echo -e "${GREEN}✓ Helm repositories ready${NC}"
echo

echo -e "${BLUE}${BOLD}==> Installing ArgoCD...${NC}"
helm upgrade --install argocd \
  argo/argo-cd \
  -n argocd \
  --timeout 8m \
  --set configs.params."server\.insecure"=true

echo -e "${GREEN}✓ ArgoCD installation completed${NC}"
echo

echo -e "${BLUE}${BOLD}==> Installing Kyverno...${NC}"
helm upgrade --install kyverno \
  kyverno/kyverno \
  --namespace kyverno \
  --create-namespace \
  --timeout 8m \
  --set features.policyExceptions.enabled=true \
  --set features.policyExceptions.namespace=argocd

echo -e "${GREEN}✓ Kyverno installation completed${NC}"
echo

echo -e "${BLUE}${BOLD}==> Installing Falco...${NC}"

helm upgrade --install falco \
  falcosecurity/falco \
  --namespace falco \
  --create-namespace \
  --timeout 8m \
  --set tty=true \
  --set falcosidekick.enabled=true \
  -f falco/custom-rules.yml

echo -e "${GREEN}✓ Falco installation completed${NC}"
echo

echo -e "${BLUE}${BOLD}==> Creating otel-labs namespace...${NC}"
kubectl create namespace otel-labs \
  --dry-run=client -o yaml | kubectl apply -f -

echo -e "${GREEN}✓ otel-labs namespace ready${NC}"
echo

echo -e "${BLUE}${BOLD}==> Applying New Relic and Honeycomb secrets...${NC}"
kubectl apply -f "$REPO_ROOT/k8s/otel-collector/secrets.yml"

echo -e "${GREEN}✓ Observability secrets applied${NC}"
echo

echo -e "${GREEN}${BOLD}==================================================${NC}"
echo -e "${GREEN}${BOLD}           BOOTSTRAP SCRIPT COMPLETED            ${NC}"
echo -e "${GREEN}${BOLD}==================================================${NC}"
echo