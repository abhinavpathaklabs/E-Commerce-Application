output "region" {
  description = "The region where aws is created"
  value = local.region
}

output "vpc_id" {
  description = "The VPC ID where aws resources are created"
  value       = module.vpc.vpc_id
}
output "public_subnets" {
  description = "The public subnets IDs"
  value       = module.vpc.public_subnets
}
output "private_subnets" {
  description = "The private subnets IDs"
  value       = module.vpc.private_subnets
}
output "intra_subnets" {
  description = "The intra subnets IDs"
  value       = module.vpc.intra_subnets
}

output "eks_cluster_id" {
  description = "The EKS Cluster ID"
  value       = module.eks.cluster_id
}   


output "eks_cluster_endpoint" {
  description = "The EKS Cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "The EKS Cluster version"
  value       = module.eks.cluster_version
}

output "eks_node_instance_ids" {
  description = "The EKS Node Instance IDs"
  value       = data.aws_instances.eks_nodes.ids
}

output "node_public_ip" {
    description = "The EKS Node Public IPs"
    value       = data.aws_instances.eks_nodes.public_ips
  
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}