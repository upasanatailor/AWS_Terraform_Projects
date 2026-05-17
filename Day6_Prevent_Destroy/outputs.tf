output "ec2_public_ip" {
  value = aws_instance.main.public_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "sg_id" {
  value = aws_security_group.main.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.data.bucket
}

output "ami_used" {
  description = "AMI Terraform resolved automatically"
  value       = data.aws_ami.amazon_linux.id
}
