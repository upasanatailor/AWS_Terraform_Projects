locals {
  tags = {
    Name        = var.name
    Environment = var.environment
    App         = var.app
    ManagedBy   = "terraform"
    DeployedAt  = timestamp()
  }
}

data "aws_vpc" "vpc_name" {
  default = true # fetches the default VPC
}

data "aws_subnet" "shared_subnet" {
  filter {
    name   = "availabilityZone"
    values = [var.availability_zone]
  }
  vpc_id = data.aws_vpc.vpc_name.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20251126"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.shared_subnet.id
  tags = local.tags
}
