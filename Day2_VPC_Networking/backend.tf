# This Terraform configuration sets up an AWS S3 bucket for Terraform state storage
resource "aws_s3_bucket" "terraform-lock" {
  bucket = var.s3_bucket_name
  tags = {
    Name        = "terraform-lock"
    Environment = var.environment
  }
}

# Create DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "networking-terraform" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"    
  hash_key       = "LockID"   
  attribute {
    name = "LockID"
    type = "S"  
  }
}
