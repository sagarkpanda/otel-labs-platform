#!/bin/bash

OUT=verify.txt

{
echo "===== ROOT KUSTOMIZE ====="
kubectl kustomize k8s

echo
echo "===== ROOT RESOURCE KINDS ====="
kubectl kustomize k8s | grep "^kind:"

echo
echo "===== ROOT DRY RUN ====="
kubectl apply --dry-run=client -k k8s

echo
echo "===== NODE FRONTEND ====="
kubectl kustomize k8s/node-frontend

echo
echo "===== PYTHON ORDERS ====="
kubectl kustomize k8s/python-orders

echo
echo "===== GO INVENTORY ====="
kubectl kustomize k8s/go-inventory

echo
echo "===== OTEL COLLECTOR ====="
kubectl kustomize k8s/otel-collector

echo
echo "===== FILE TREE ====="
find k8s -type f | sort

echo
echo "===== ROOT KUSTOMIZATION ====="
cat k8s/kustomization.yml

echo
echo "===== NODE KUSTOMIZATION ====="
cat k8s/node-frontend/kustomization.yml

echo
echo "===== PYTHON KUSTOMIZATION ====="
cat k8s/python-orders/kustomization.yml

echo
echo "===== GO KUSTOMIZATION ====="
cat k8s/go-inventory/kustomization.yml

echo
echo "===== OTEL KUSTOMIZATION ====="
cat k8s/otel-collector/kustomization.yml

echo
echo "===== HTTPROUTE ====="
cat k8s/node-frontend/httproute.yml

} > "$OUT" 2>&1

echo "Generated $OUT"
wc -l "$OUT"
