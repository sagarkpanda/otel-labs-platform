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
echo "===== DIRECTORY TREE ====="
tree -a -L 5 -I '.git|.terraform'

echo
echo "===== TOP LEVEL ====="
ls -la

echo
echo "===== REPO FILES ====="
find . \
  -path './.git' -prune -o \
  -path './terraform/.terraform' -prune -o \
  -type f -print | sort

echo
echo "===== TERRAFORM TREE ====="
tree -a terraform -I '.terraform' 2>/dev/null

echo
echo "===== TERRAFORM FILES ====="
find terraform \
  -path 'terraform/.terraform' -prune -o \
  -type f -print | sort

echo
echo "===== TERRAFORM VALIDATE ====="
(
  cd terraform &&
  tofu validate
)

echo
echo "===== TERRAFORM FORMAT CHECK ====="
(
  cd terraform &&
  tofu fmt -check
)

echo
echo "===== TF FILE CONTENTS ====="
find terraform -name "*.tf" | sort | while read -r f; do
  echo
  echo "### $f ###"
  cat "$f"
done

echo
echo "===== K8S TREE ====="
tree -a k8s 2>/dev/null

echo
echo "===== K8S FILES ====="
find k8s -type f 2>/dev/null | sort

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
echo "===== ALL KUSTOMIZATION FILES ====="
find k8s -name "kustomization.y*" | sort | while read -r f; do
  echo
  echo "### $f ###"
  cat "$f"
done

echo
echo "===== ALL YAML FILES ====="
find k8s \( -name "*.yaml" -o -name "*.yml" \) | sort | while read -r f; do
  echo
  echo "### $f ###"
  cat "$f"
done

echo
echo "===== ARGOCD TREE ====="
tree -a k8s/argocd 2>/dev/null

echo
echo "===== ARGOCD FILES ====="
find k8s/argocd -type f 2>/dev/null | sort

echo
echo "===== APPLICATIONS ====="
grep -R "^kind: Application" k8s 2>/dev/null

echo
echo "===== APPLICATION FINALIZERS ====="
grep -R "resources-finalizer.argocd.argoproj.io" k8s 2>/dev/null

echo
echo "===== STORAGE FILES ====="
find k8s -iname "*storage*" -o -iname "*gp3*" 2>/dev/null

echo
echo "===== VAULT FILES ====="
find k8s -iname "*vault*" 2>/dev/null

echo
echo "===== ESO FILES ====="
find k8s -iname "*secretstore*" -o -iname "*externalsecret*" 2>/dev/null

echo
echo "===== HELM FILES ====="
find . \
  -path './.git' -prune -o \
  -path './terraform/.terraform' -prune -o \
  \( -name Chart.yaml -o -name values.yaml \) -print

echo
echo "===== YAML COUNT ====="
find . \
  -path './.git' -prune -o \
  -path './terraform/.terraform' -prune -o \
  \( -name "*.yaml" -o -name "*.yml" \) -print | wc -l

echo
echo "===== TF COUNT ====="
find . \
  -path './.git' -prune -o \
  -path './terraform/.terraform' -prune -o \
  -name "*.tf" -print | wc -l

echo
echo "===== GITIGNORE ====="
cat .gitignore

echo
echo "===== GIT STATUS ====="
git status

echo
echo "===== GIT REMOTES ====="
git remote -v

echo
echo "===== RECENT COMMITS ====="
git log --oneline -20

} > "$OUT" 2>&1

echo "Generated $OUT"
wc -l "$OUT"