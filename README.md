# Project Bedrock — Capstone Deployment Guide

## Architecture Overview
- **VPC**: `project-bedrock-vpc` with public and private subnets across 3 AZs in `us-east-1`
- **EKS Cluster**: `project-bedrock-cluster` (Kubernetes v1.33)
- **Data Layer**: Aurora MySQL (catalog), Aurora PostgreSQL (orders), DynamoDB (carts), ElastiCache Redis (checkout), AmazonMQ RabbitMQ (orders messaging)
- **Ingress**: AWS Load Balancer Controller + ALB
- **Observability**: CloudWatch Observability EKS Add-on (FluentBit)
- **Serverless**: S3 + Lambda event trigger
- **CI/CD**: GitHub Actions (plan on PR, apply on merge)

## Prerequisites
- AWS CLI configured with sufficient permissions
- Terraform >= 1.0.0
- kubectl
- helm

## Triggering the Pipeline

### PR triggers terraform plan
1. Create a new branch: `git checkout -b feature/my-change`
2. Make changes, commit and push
3. Open a Pull Request to `main`
4. GitHub Actions will run `terraform plan` and post output as a PR comment

### Merge to main triggers terraform apply
1. Merge the PR to `main`
2. GitHub Actions will run `terraform apply` automatically

## Manual Deployment

```bash
cd retail-store-sample-app/terraform/eks/default

# Initialise
terraform init

# Plan
terraform plan -var-file="terraform.tfvars" -out=tfplan

# Apply
terraform apply tfplan
```

## Accessing the Application

After apply completes, get the ALB URL:
```bash
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster
kubectl get ingress -n ui
```

## Developer Access

The `bedrock-dev-view` IAM user has:
- AWS Console ReadOnly access
- Kubernetes RBAC `view` ClusterRole

Verify access:
```bash
# Configure kubectl with dev user credentials
aws configure --profile bedrock-dev
kubectl get pods -n retail-app   # should work
kubectl delete pod -n retail-app  # should fail
```

## Grading Credentials
See the submitted Google Document for:
- `bedrock-dev-view` Access Key ID and Secret
- Console login credentials

## Generating grading.json
```bash
cd retail-store-sample-app/terraform/eks/default
terraform output -json > ../../../../grading.json
```
# Project Bedrock - Karatu 2025 Capstone
# tested
## CI/CD Pipeline Demo
