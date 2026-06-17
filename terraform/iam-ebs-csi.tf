# resource "aws_iam_role" "ebs_csi" {
#   name = "AmazonEBSCSIRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "pods.eks.amazonaws.com"
#       }
#       Action = [
#         "sts:AssumeRole",
#         "sts:TagSession"
#       ]
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ebs_csi" {
#   role       = aws_iam_role.ebs_csi.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
# }

# resource "aws_eks_pod_identity_association" "ebs_csi" {
#   cluster_name    = aws_eks_cluster.otel_labs.name
#   namespace       = "kube-system"
#   service_account = "ebs-csi-controller-sa"

#   role_arn = aws_iam_role.ebs_csi.arn
# }