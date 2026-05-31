module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = false

  enable_dns_support   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                   = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}"      = "shared"
    "kubernetes.io/role/internal-elb"                = "1"
    "kubernetes.io/role/compute"                     = "1"
  }

  tags = {
    Environment = var.environment
    Name        = "${var.cluster_name}-vpc"
  }
}

