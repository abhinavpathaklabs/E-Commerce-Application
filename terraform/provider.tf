


locals {
  
  region = "us-east-2"
  name = "Commerce-App-EKS-Cluster"
  vpc_cidr = "10.0.0.0/16"
  azs = ["us-east-2a", "us-east-2b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  intra_subnets   = ["10.0.5.0/24", "10.0.6.0/24"]

  tags = {
    example =  local.name
    Terraform   = "true"
    Environment = "dev"
  }
}

provider "aws" {
  region = local.region
}