# Output Public IP of EC2 Instance
output "public_instance_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2-networking[*].public_ip
}

# Output Private IP of EC2 Instance
output "private_instance_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ec2-networking[*].private_ip
}

# Output EC2 Instance IDs
output "ec2_instance_ids" {
  description = "EC2 instance IDs"
  value       = aws_instance.ec2-networking[*].id
}