resource "aws_s3_bucket" "my_bucket" {
    bucket              = "day4-drift-detection" # Change to a unique bucket name
    object_lock_enabled = false
    tags                = {
        name = "my_bucket_manual"
        ManagedBy = "Terraform" 
    }
  
}

resource "aws_instance" "name" {
  ami = "ami-091138d0f0d41ff90"
  instance_type = "t2.micro"
  
  tags = {
    name = "aws-server-day4"
    ManagedBy = "Terraform"
  }
}


resource "aws_security_group" "server-day4" {
    name        = "mmy-manual-sg-day4"
    description = "Security group for my manual EC2 instance"
    vpc_id      = "vpc-0a2cc7edce3285d05"
    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }   
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      name = "my-manual-sg-day4"
      ManagedBy = "Terraform"
    }
}
