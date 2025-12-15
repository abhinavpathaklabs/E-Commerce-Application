data "aws_ami" "os_image" {

  owners           = ["099720109477"]
  most_recent      = true
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/*24.04-amd64*"]
  } 
}

resource "aws_key_pair" "deployer" {
  key_name   = "terra-automate-key"
  public_key = file("terra-key.pub")
}


resource "aws_security_group" "allow_user_to_connect" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "my-security-group"
  }

  ingress {
    description = "allow SSH access from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    ingress  {
        description = "allow HTTP access from anywhere"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "allow HTTPS access from anywhere"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
 
    

}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.os_image.id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_user_to_connect.id]
  associate_public_ip_address = true
  user_data = file("${path.module}/install_tool.sh")

  tags = {
    Name        = "Jenkins-Server"
    Environment = var.my_enviroment
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
}
  