# Create EC2 Instance
resource "aws_instance" "ec2-networking" {
  count                       = var.instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public-subnet-networking.id
  vpc_security_group_ids      = [aws_security_group.sec-networking.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "ec2-networking"
  }
}
