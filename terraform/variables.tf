variable "aws_region" {
    description = "Region where AWS_Resources is going to be provisioned"
    default = "us-east-2"
}

variable "ami_id" {
    description = "AMI ID for the instance"
    default = "ami-0f5fcdfbd140e4ab7"
}

variable "instance_type" {
    description = "AMI ID for the instance"
    default = "m7i-flex.large"
}

variable "my_enviroment" {
  description = "Instance enviroment for the EC2 instance"
  default     = "dev"
}