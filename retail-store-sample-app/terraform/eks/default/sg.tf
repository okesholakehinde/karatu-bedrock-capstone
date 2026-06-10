resource "aws_security_group" "catalog" {
  name        = "${var.environment_name}-catalog"
  description = "Security group for catalog component"
  vpc_id      = module.vpc.inner.vpc_id

  ingress {
    description = "Allow inbound HTTP API traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [module.vpc.inner.vpc_cidr_block]
  }

  ingress {
    description = "Allow inbound Istio healthchecks"
    from_port   = 15020
    to_port     = 15021
    protocol    = "tcp"
    cidr_blocks = [module.vpc.inner.vpc_cidr_block]
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.tags.result
}

resource "aws_security_group" "orders" {
  name        = "${var.environment_name}-orders"
  description = "Security group for orders component"
  vpc_id      = module.vpc.inner.vpc_id

  ingress {
    description = "Allow inbound HTTP API traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [module.vpc.inner.vpc_cidr_block]
  }

  ingress {
    description = "Allow inbound Istio healthchecks"
    from_port   = 15020
    to_port     = 15021
    protocol    = "tcp"
    cidr_blocks = [module.vpc.inner.vpc_cidr_block]
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.tags.result
}

resource "aws_security_group" "checkout" {
  name        = "${var.environment_name}-checkout"
  description = "Security group for checkout component"
  vpc_id      = module.vpc.inner.vpc_id

  ingress {
    description = "Allow inbound HTTP API traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [module.vpc.inner.vpc_cidr_block]
  }

  ingress {
    description = "Allow inbound Istio healthchecks"
    from_port   = 15020
    to_port     = 15021
    protocol    = "tcp"
    cidr_blocks = [module.vpc.inner.vpc_cidr_block]
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.tags.result
}
resource "aws_security_group_rule" "catalog_rds_from_eks" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = "sg-0252de721d51b41b8"
  source_security_group_id = "sg-0df5b607ae4272466"
  description              = "Allow EKS nodes to reach catalog RDS MySQL"
}

resource "aws_security_group_rule" "orders_rds_from_eks" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = "sg-0d564e7aa6af32b43"
  source_security_group_id = "sg-0df5b607ae4272466"
  description              = "Allow EKS nodes to reach orders RDS PostgreSQL"
}
