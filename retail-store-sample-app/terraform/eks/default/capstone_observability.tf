# IAM role for the CloudWatch agent using IRSA
resource "aws_iam_role" "cloudwatch_agent" {
  name = "${var.environment_name}-cloudwatch-agent"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(module.retail_app_eks.eks_oidc_issuer_url, "https://", "")}"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(module.retail_app_eks.eks_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:amazon-cloudwatch:cloudwatch-agent"
        }
      }
    }]
  })

  tags = { Project = "karatu-2025-capstone" }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.cloudwatch_agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# CloudWatch Observability EKS add-on
# Installs FluentBit on every node and ships container logs to CloudWatch
resource "aws_eks_addon" "cloudwatch_observability" {
  cluster_name             = module.retail_app_eks.eks_cluster_id
  addon_name               = "amazon-cloudwatch-observability"
  service_account_role_arn = aws_iam_role.cloudwatch_agent.arn

  tags = { Project = "karatu-2025-capstone" }

  depends_on = [module.retail_app_eks]
}
