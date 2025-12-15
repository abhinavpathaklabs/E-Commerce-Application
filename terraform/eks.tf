module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name    = local.name

  kubernetes_version = "1.33"

  addons = {
    coredns                = {most_recent = true}
    kube-proxy             = {most_recent = true}
    vpc-cni                = {
      most_recent = true
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    ecommerce-demo-ng = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      min_size = 2
      max_size = 5
      desired_size = 2
      capacity_type = "SPOT"
      instance_types = ["t3.small"]
      disk_size = 20
      use_custom_launch_template = false

    }
    tags = {
      Name = "ecommerce-demo-ng"
      ExtraTag = "e-commerce-app"
      Environment = "dev"
    }   

  }

  tags = local.tags

}

data "aws_instances" "eks_nodes" {
    instance_tags = {
        "eks:cluster-name" = module.eks.cluster_name
    }   

    filter {
      name = "instance-state-name"
      values = ["running"]

    }
    depends_on = [ module.eks ]
  
}