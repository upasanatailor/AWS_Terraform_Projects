# Create Internet Gateway
resource "aws_internet_gateway" "igw-networking" {
  vpc_id = aws_vpc.vpc-networking.id
}

# Create Route Table
resource "aws_route_table" "rt-networking" {
  vpc_id = aws_vpc.vpc-networking.id
  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.igw-networking.id
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "rta-networking" {
  subnet_id      = aws_subnet.public-subnet-networking.id
  route_table_id = aws_route_table.rt-networking.id
}
