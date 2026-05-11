# Create VPC
resource "aws_vpc" "vpc-networking" {
  cidr_block = var.vpc_cidr
}

# Create Public Subnet
resource "aws_subnet" "public-subnet-networking" {
  vpc_id                  = aws_vpc.vpc-networking.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
}

# Create Private Subnet
resource "aws_subnet" "private-subnet-networking" {
  vpc_id            = aws_vpc.vpc-networking.id
  cidr_block        = var.private_subnet_cidr
}
