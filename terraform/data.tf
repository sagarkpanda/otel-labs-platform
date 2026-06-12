data "aws_caller_identity" "current" {}

data "aws_iam_role" "cluster_role" {
  name = "AmazonEKSClusterRole_Sagar"
}

data "aws_iam_role" "node_role" {
  name = "AmazonEKSAutoNodeRole"
}