# resource "kubernetes_namespace" "traefik" {
#   metadata {
#     name = "traefik"
#   }

#   depends_on = [
#     aws_eks_node_group.eksng
#   ]
# }

# resource "helm_release" "traefik" {
#   name       = "traefik"
#   namespace  = kubernetes_namespace.traefik.metadata[0].name

#   repository = "https://traefik.github.io/charts"
#   chart      = "traefik"

#   depends_on = [
#     kubernetes_namespace.traefik
#   ]
# }