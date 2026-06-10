terraform {
  backend "s3" {
    bucket  = "bedrock-tf-state-3356"
    key     = "project-bedrock/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
