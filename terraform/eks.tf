resource "aws_eks_cluster" "otel_labs" {
  name     = var.cluster_name
  role_arn = data.aws_iam_role.cluster_role.arn

  version = "1.36"

  vpc_config {
    subnet_ids = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ]
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  tags = merge(
    local.common_tags,
    {
      Name = var.cluster_name
    }
  )
}

resource "aws_eks_access_entry" "cluster_admin" {
  cluster_name  = aws_eks_cluster.otel_labs.name
  principal_arn = data.aws_caller_identity.current.arn

  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "cluster_admin" {
  cluster_name  = aws_eks_cluster.otel_labs.name
  principal_arn = aws_eks_access_entry.cluster_admin.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_node_group" "eksng" {
  cluster_name    = aws_eks_cluster.otel_labs.name
  node_group_name = "eksng"

  node_role_arn = data.aws_iam_role.node_role.arn

  subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  instance_types = ["t3.medium"]

  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  tags = merge(
    local.common_tags,
    {
      Name = "eksng"
    }
  )
}

resource "null_resource" "bootstrap_argocd" {

  depends_on = [
    aws_eks_node_group.eksng,
    aws_eks_access_policy_association.cluster_admin
  ]

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = "./bootstrap.sh || true"
  }
}