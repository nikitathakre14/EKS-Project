output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_ca_certificate_data" {
  description = "EKS cluster CA certificate"
  value       = module.eks.cluster_certificate_authority_data
}

output "vpc_id" {
  description = "VPC ID for the cluster"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs for the cluster"
  value       = module.vpc.private_subnets
}
