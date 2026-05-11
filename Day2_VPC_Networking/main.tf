# Main Terraform configuration file
# All resources are now organized in separate files:
# - backend.tf: S3 bucket and DynamoDB for state management
# - vpc.tf: VPC and subnet definitions
# - networking.tf: Internet Gateway, Route Tables
# - security_groups.tf: Security Group definitions
# - compute.tf: EC2 instances
