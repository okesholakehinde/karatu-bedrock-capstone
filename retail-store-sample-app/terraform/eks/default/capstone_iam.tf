# IAM user for developers
resource "aws_iam_user" "dev_view" {
  name = "bedrock-dev-view"
  tags = { Project = "karatu-2025-capstone" }
}

# Console login profile
resource "aws_iam_user_login_profile" "dev_view" {
  user                    = aws_iam_user.dev_view.name
  password_reset_required = false
}

# Programmatic access keys
resource "aws_iam_access_key" "dev_view" {
  user = aws_iam_user.dev_view.name
}

# AWS Console read-only access
resource "aws_iam_user_policy_attachment" "dev_view_readonly" {
  user       = aws_iam_user.dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# S3 PutObject on the assets bucket only
resource "aws_iam_user_policy" "dev_view_s3" {
  name = "bedrock-dev-s3-putobject"
  user = aws_iam_user.dev_view.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowAssetUpload"
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.assets.arn}/*"
      }
    ]
  })
}

# Map IAM user to Kubernetes view ClusterRole
resource "kubernetes_cluster_role_binding_v1" "dev_view" {
  metadata {
    name = "bedrock-dev-view-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  subject {
    kind      = "User"
    name      = "bedrock-dev-view"
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [module.retail_app_eks]
}

# Add IAM user to aws-auth configmap so EKS recognises it
resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  force = true

  data = {
    mapUsers = yamlencode([
      {
        userarn  = aws_iam_user.dev_view.arn
        username = "bedrock-dev-view"
        groups   = ["view-group"]
      }
    ])
  }

  depends_on = [module.retail_app_eks]
}
