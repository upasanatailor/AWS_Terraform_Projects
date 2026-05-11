
variable "region" {
  type        = string
  description = "AWS region to deploy resources in"
  default     = "us-east-1"

}



# This file contains variable definitions for the production environment.

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the web server"

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Instance type must be one of: t2.micro, t3.micro, t3.small"
  }
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet"
}

# The CIDR block for the VPC. Adjust as needed for your network design.
variable "VPC_CIDR" {
  type        = string
  description = "CIDR block for the VPC"

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]+$", var.VPC_CIDR))
    error_message = "VPC_CIDR must be a valid CIDR block (e.g., 10.0.0.0/16)"
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment name"


  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}



variable "app_name" {
  type        = string
  description = "Name of the application being deployed"

}

variable "DB_password" {
  type        = string
  description = "Password for the database"
  sensitive   = true
}
  