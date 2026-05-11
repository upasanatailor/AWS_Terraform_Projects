# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnet Configuration
variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# Security Group
variable "sec_name" {
  description = "Name of security group"
  type        = string
  default     = "sec-networking"
}

variable "sec_description" {
  description = "Description of security group"
  type        = string
  default     = "Security group for networking project"
}

# EC2 Configuration
variable "ami_id" {
  description = "Amazon Machine Image ID"
  type        = string
  default     = "ami-0c94855ba95c71c99"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

# Terraform State Management
variable "s3_bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = "bucket-terraform-state-networking"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for state locking"
  type        = string
  default     = "networking-terraform"
}

# Tags
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "Dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "networking"
}
