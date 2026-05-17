output "bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}

output "sg_id" {
  value = aws_security_group.server-day4.id
}

output "ec2_id" {
  value = aws_instance.aws-server-day4.id
}

output "ec2_public_ip" {
  value = aws_instance.aws-server-day4.public_ip
}