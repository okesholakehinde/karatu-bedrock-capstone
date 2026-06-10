# Required outputs for grading script
output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.retail_app_eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.retail_app_eks.eks_cluster_id
}

output "region" {
  description = "AWS region"
  value       = "us-east-1"
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.inner.vpc_id
}

output "assets_bucket_name" {
  description = "S3 assets bucket name"
  value       = aws_s3_bucket.assets.id
}

# Developer credentials for grading submission
output "dev_user_access_key_id" {
  description = "Access Key ID for bedrock-dev-view"
  value       = aws_iam_access_key.dev_view.id
}

output "dev_user_secret_access_key" {
  description = "Secret Access Key for bedrock-dev-view"
  value       = aws_iam_access_key.dev_view.secret
  sensitive   = true
}

output "dev_user_console_password" {
  description = "Console password for bedrock-dev-view"
  value       = aws_iam_user_login_profile.dev_view.password
  sensitive   = true
}
