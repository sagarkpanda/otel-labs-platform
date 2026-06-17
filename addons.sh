K8S_VERSION=1.36

{
  for addon in coredns kube-proxy vpc-cni
  do
    echo "=== $addon ==="

    aws eks describe-addon-versions \
      --addon-name $addon \
      --kubernetes-version $K8S_VERSION \
      --query 'addons[].addonVersions[?compatibilities[?defaultVersion==`true`]].addonVersion' \
      --output text

    echo
  done
} | tee eks_addons.txt