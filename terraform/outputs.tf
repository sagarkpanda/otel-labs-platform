output "vpc_id" {
  value = aws_vpc.eks.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_b.id
}

output "cluster_name" {
  value = aws_eks_cluster.otel_labs.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.otel_labs.endpoint
}

output "node_group_name" {
  value = aws_eks_node_group.eksng.node_group_name
}

output "terraform_caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --region ap-south-1 --name ${aws_eks_cluster.otel_labs.name}"
}

output "argocd_password_command" {
  value = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo"
}