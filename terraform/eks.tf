module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true
  create_oidc_provider = true

  cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  managed_node_groups = {
    app_nodes = {
      desired_size = 2
      max_size     = 5
      min_size     = 2

      instance_types = var.node_instance_types
      subnet_ids      = module.vpc.private_subnets
      additional_security_group_ids = [aws_security_group.eks_nodes.id]

      labels = {
        role = "application"
      }

      tags = {
        Name        = "${var.cluster_name}-nodes"
        Environment = var.environment
      }
    }
  }

  tags = {
    Environment = var.environment
  }
}

