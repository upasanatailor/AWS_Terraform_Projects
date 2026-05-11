# Create Security Group
resource "aws_security_group" "sec-networking" {
  name        = var.sec_name
  description = var.sec_description
  vpc_id      = aws_vpc.vpc-networking.id  
  
  ingress {
    from_port   = 80
    to_port     = 80
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
