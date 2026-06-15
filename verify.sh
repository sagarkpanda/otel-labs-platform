# #!/bin/bash

# OUT=verify.txt

# {
# echo "===== ROOT KUSTOMIZE ====="
# kubectl kustomize k8s

# echo
# echo "===== ROOT RESOURCE KINDS ====="
# kubectl kustomize k8s | grep "^kind:"

# echo
# echo "===== ROOT DRY RUN ====="
# kubectl apply --dry-run=client -k k8s

# echo
# echo "===== NODE FRONTEND ====="
# kubectl kustomize k8s/node-frontend

# echo
# echo "===== PYTHON ORDERS ====="
# kubectl kustomize k8s/python-orders

# echo
# echo "===== GO INVENTORY ====="
# kubectl kustomize k8s/go-inventory

# echo
# echo "===== OTEL COLLECTOR ====="
# kubectl kustomize k8s/otel-collector

# echo
# echo "===== FILE TREE ====="
# find k8s -type f | sort

# echo
# echo "===== ROOT KUSTOMIZATION ====="
# cat k8s/kustomization.yml

# echo
# echo "===== NODE KUSTOMIZATION ====="
# cat k8s/node-frontend/kustomization.yml

# echo
# echo "===== PYTHON KUSTOMIZATION ====="
# cat k8s/python-orders/kustomization.yml

# echo
# echo "===== GO KUSTOMIZATION ====="
# cat k8s/go-inventory/kustomization.yml

# echo
# echo "===== OTEL KUSTOMIZATION ====="
# cat k8s/otel-collector/kustomization.yml

# echo
# echo "===== HTTPROUTE ====="
# cat k8s/node-frontend/httproute.yml

# } > "$OUT" 2>&1

# echo "Generated $OUT"
# wc -l "$OUT"

#!/bin/bash

OUT=verify.txt

{
echo "===== FILE TREE ====="
find k8s -type f | sort

echo
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
echo "===== ARGOCD FILES ====="
find k8s/argocd -type f | sort

echo
echo "===== ROOT APP ====="
cat k8s/argocd/root-app.yml

echo
echo "===== TRAEFIK APP ====="
cat k8s/argocd/traefik-app.yml

echo
echo "===== NODE FRONTEND APP ====="
cat k8s/argocd/node-frontend-app.yml

echo
echo "===== PYTHON ORDERS APP ====="
cat k8s/argocd/python-orders-app.yml

echo
echo "===== GO INVENTORY APP ====="
cat k8s/argocd/go-inventory-app.yml

echo
echo "===== OTEL COLLECTOR APP ====="
cat k8s/argocd/otel-collector-app.yml

echo
echo "===== ARGOCD INGRESS ====="
cat k8s/infra/argo/argo-ingress.yml

echo
echo "===== APPLICATION FINALIZERS ====="
grep -R "resources-finalizer.argocd.argoproj.io" k8s/argocd

} > "$OUT" 2>&1

echo "Generated $OUT"
wc -l "$OUT"