# Day 6 — Terraform Lifecycle Rules

## What You Will Learn
- How to do zero downtime deployments using create_before_destroy
- How to protect critical resources from accidental deletion using prevent_destroy
- How to ignore specific attribute changes using ignore_changes
- When to use each rule and when NOT to use them

## Exam Topics Covered
- lifecycle block syntax
- create_before_destroy behaviour
- prevent_destroy limitation
- ignore_changes with specific attributes vs all
- Resource replacement vs in-place update

## Interview Questions You Can Answer After This
- "How do you do zero downtime deployments in Terraform?"
- "How do you protect critical resources from accidental deletion?"
- "When would you use ignore_changes and why is it dangerous?"
- "What is the difference between +/- and -/+ in terraform plan output?"

---

## Folder Structure

```
day6/
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
└── outputs.tf
```

---

## provider.tf

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "your-state-bucket-name"
    key            = "day6/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-lock-table-name"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
```

---

## variables.tf

```hcl
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "app_name" {
  type    = string
  default = "myapp"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

---

## terraform.tfvars

```hcl
region             = "us-east-1"
environment        = "dev"
app_name           = "myapp"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
instance_type      = "t2.micro"
```

---

## main.tf — Full Solution

```hcl
# ── LOCALS ─────────────────────────────────────────────────────
locals {
  prefix = "${var.app_name}-${var.environment}"

  common_tags = {
    Environment = var.environment
    App         = var.app_name
    ManagedBy   = "Terraform"
  }
}

# ── VPC ────────────────────────────────────────────────────────
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-vpc"
  })
}

# ── PUBLIC SUBNET ───────────────────────────────────────────────
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-public-subnet"
  })
}

# ── INTERNET GATEWAY ────────────────────────────────────────────
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-igw"
  })
}

# ── ROUTE TABLE ─────────────────────────────────────────────────
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ── SECURITY GROUP ──────────────────────────────────────────────
# LIFECYCLE RULE 1: create_before_destroy
# Problem it solves: when SG needs replacement, EC2 would have
# no SG for a moment causing downtime. This rule ensures the
# new SG is fully created before the old one is destroyed.
resource "aws_security_group" "main" {
  name        = "${local.prefix}-sg"
  description = "Allow SSH and HTTP only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# ── S3 BUCKET ───────────────────────────────────────────────────
# LIFECYCLE RULE 2: prevent_destroy
# Problem it solves: accidental terraform destroy wiping
# critical data. This blocks the destroy operation entirely.
# WARNING: removing this block from code removes the protection!
resource "aws_s3_bucket" "data" {
  bucket = "${local.prefix}-critical-data-2026"

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-critical-data"
  })

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ── DATA SOURCE: latest Amazon Linux 2023 AMI ───────────────────
# Automatically fetches the latest AMI — no hardcoding needed
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# ── EC2 INSTANCE ────────────────────────────────────────────────
# LIFECYCLE RULE 3: ignore_changes
# Problem it solves: external pipelines update the AMI and
# user_data on running instances. Without this rule Terraform
# would revert those changes every time someone runs apply.
resource "aws_instance" "main" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.main.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
  EOF

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-ec2"
  })

  lifecycle {
    ignore_changes = [
      ami,
      user_data
    ]
  }
}
```

---

## outputs.tf

```hcl
output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.main.public_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "sg_id" {
  description = "Security Group ID"
  value       = aws_security_group.main.id
}

output "s3_bucket_name" {
  description = "Protected S3 bucket name"
  value       = aws_s3_bucket.data.bucket
}

output "ami_used" {
  description = "AMI ID Terraform resolved automatically via data source"
  value       = data.aws_ami.al2023.id
}
```

---

## Commands — Run in Order

```bash
# Format and validate
terraform fmt
terraform validate

# Initialize
terraform init

# Preview
terraform plan

# Deploy
terraform apply
```

---

## Testing Each Lifecycle Rule

### Test 1 — create_before_destroy

Change the SG description in main.tf to force a replacement:

```hcl
# before
description = "Allow SSH and HTTP only"

# after — change triggers replacement
description = "Allow SSH and HTTP - updated"
```

Run plan and look for `+/-` symbol:

```bash
terraform plan
```

Expected output:
```
# aws_security_group.main must be replaced
+/- resource "aws_security_group" "main" {
```

What the symbols mean:

| Symbol | Meaning |
|---|---|
| `+/-` | create first then destroy — safe |
| `-/+` | destroy first then create — causes downtime |

Do NOT apply this change — it is just for observation.
Revert the description back after testing.

---

### Test 2 — prevent_destroy

```bash
terraform destroy
```

Expected error — destroy is completely blocked:
```
Error: Instance cannot be destroyed

  on main.tf line XX, in resource "aws_s3_bucket" "data":
  XX:   prevent_destroy = true

This object is protected from destroy operation.
```

Now test the big caveat — remove the lifecycle block and apply:

```hcl
# comment out prevent_destroy
resource "aws_s3_bucket" "data" {
  bucket = "${local.prefix}-critical-data-2026"
  # lifecycle {
  #   prevent_destroy = true
  # }
}
```

```bash
terraform apply
terraform destroy   # this will now SUCCEED — protection is gone!
```

This is the exam trap — prevent_destroy only works while the
block exists in code. Removing the block removes the protection.

Restore the lifecycle block after this test.

---

### Test 3 — ignore_changes

```bash
# Go to AWS console
# EC2 → your instance → Actions → Instance Settings → Edit user data
# Change anything in the user data script
# Save it

# Come back to terminal
terraform plan
```

Expected output:
```
No changes. Your infrastructure matches the configuration.
```

Terraform completely ignored the external change to user_data.
That is ignore_changes working correctly.

---

## Clean Up

You must remove prevent_destroy before destroying — otherwise destroy fails.

```hcl
# In main.tf — comment out or remove the lifecycle block on S3
resource "aws_s3_bucket" "data" {
  bucket = "${local.prefix}-critical-data-2026"

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-critical-data"
  })

  # lifecycle {
  #   prevent_destroy = true
  # }
}
```

Then destroy:

```bash
terraform apply   # apply the removal of prevent_destroy first
terraform destroy
```

---

## Golden Rules — Lifecycle

| Rule | Use When | Avoid When |
|---|---|---|
| create_before_destroy | SG, certs, LB replacement | Resources that cannot have duplicates |
| prevent_destroy | S3, RDS, critical data | Dev/test resources you destroy often |
| ignore_changes | AMI, user_data managed externally | Security rules — drift becomes invisible |
| ignore_changes = all | Almost never | Production — you lose all drift detection |

---

## Plan Output Cheat Sheet — Exam Favourite

| Symbol | Meaning |
|---|---|
| `+` | Resource will be created |
| `-` | Resource will be destroyed |
| `~` | Resource will be updated in place |
| `+/-` | Create new first then destroy old (create_before_destroy) |
| `-/+` | Destroy old first then create new (default replacement) |

---

## Common Mistakes

| Mistake | What Happens |
|---|---|
| Forget to remove prevent_destroy before destroy | Destroy always fails |
| Use ignore_changes = all | All drift becomes invisible in production |
| Remove lifecycle block thinking prevent_destroy still works | It does not — block must stay in code |
| Not running apply after removing prevent_destroy | Destroy still fails |
| Using create_before_destroy on resources with unique name constraint | AWS rejects duplicate name — add random suffix |

---

## Bonus — Add Random Suffix to Avoid Name Conflicts

When using create_before_destroy on named resources AWS may
reject two resources with the same name existing at once.
Fix this by adding a random suffix:

```hcl
resource "random_id" "sg_suffix" {
  byte_length = 4
}

resource "aws_security_group" "main" {
  name = "${local.prefix}-sg-${random_id.sg_suffix.hex}"

  lifecycle {
    create_before_destroy = true
  }
}
```

This ensures the new SG gets a different name from the old one
so both can exist at the same time during replacement.

---
