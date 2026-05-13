# Day 4 — Terraform State Operations

## What You Will Learn
- How to import existing AWS resources into Terraform state
- How to detect infrastructure drift
- How to rename resources without destroying them
- How to remove resources from state safely
- Key state CLI commands used in real teams daily

## Exam Topics Covered
- `terraform import`
- `terraform state mv`, `rm`, `list`, `show`
- State drift detection
- Remote backend (S3 + DynamoDB)

## Interview Questions You Can Answer After This
- "How do you bring existing infrastructure into Terraform?"
- "What do you do when someone manually changes a resource outside Terraform?"
- "How do you rename a resource without destroying it?"
- "What is the difference between state rm and destroy?"

---

## Folder Structure

```
day4/
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
└── outputs.tf
```

---

## Step 1 — Create Resources Manually in AWS Console

Before writing any Terraform code, go to AWS console and create these 3 resources manually.
Write down all IDs — you will need them for import.

| Resource | What to note |
|---|---|
| S3 Bucket | Bucket name (must be globally unique) |
| Security Group | SG ID (sg-xxxxxxxxx) |
| EC2 Instance | Instance ID (i-xxxxxxxxx) and AMI ID |

---

## Step 2 — provider.tf

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
    key            = "day4/terraform.tfstate"
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

## Step 3 — variables.tf

```hcl
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "Your existing VPC ID from Day 2"
}
```

---

## Step 4 — terraform.tfvars

```hcl
region = "us-east-1"
vpc_id = "vpc-xxxxxxxxx"
```

---

## Step 5 — main.tf

Write resource blocks BEFORE importing.
Use AWS console or AWS CLI to read the real values.

```hcl
# ── RESOURCE 1: S3 Bucket ──────────────────────────────────────
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-manual-bucket-12345"   # exact name you created in console

  tags = {
    Name      = "my-manual-bucket"
    ManagedBy = "Terraform"
  }
}

# ── RESOURCE 2: Security Group ─────────────────────────────────
resource "aws_security_group" "main" {
  name        = "my-manual-sg"
  description = "Allow SSH"
  vpc_id      = var.vpc_id

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
    Name      = "my-manual-sg"
    ManagedBy = "Terraform"
  }
}

# ── RESOURCE 3: EC2 Instance ───────────────────────────────────
resource "aws_instance" "server" {
  ami                    = "ami-xxxxxxxxx"   # copy from AWS console EC2 page
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name      = "my-manual-ec2"
    ManagedBy = "Terraform"
  }
}
```

> Tip: You do not need to match every attribute perfectly upfront.
> Write the minimum, import, run terraform plan, and Terraform will
> tell you exactly what is missing. Add those values and repeat
> until plan shows zero changes.

---

## Step 6 — outputs.tf

```hcl
output "bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}

output "sg_id" {
  value = aws_security_group.main.id
}

output "ec2_id" {
  value = aws_instance.server.id
}

output "ec2_public_ip" {
  value = aws_instance.server.public_ip
}
```

---

## Step 7 — Initialize

```bash
terraform init
```

---

## Step 8 — Import All 3 Resources

Syntax: `terraform import <resource_type.name> <aws_resource_id>`

```bash
# Import S3 bucket — resource ID is the bucket name
terraform import aws_s3_bucket.my_bucket my-manual-bucket-12345

# Import Security Group — resource ID is the SG ID
terraform import aws_security_group.main sg-xxxxxxxxx

# Import EC2 instance — resource ID is the instance ID
terraform import aws_instance.server i-xxxxxxxxx
```

After each import you should see:
```
Import successful!
```

---

## Step 9 — Verify Plan Shows Zero Changes

```bash
terraform plan
```

Expected output:
```
No changes. Your infrastructure matches the configuration.
```

If you see changes — your resource block does not match AWS reality.
Read what Terraform says is different, update your block, run plan again.
Repeat until zero changes.

---

## Step 10 — Practice Drift Detection

```bash
# 1. Go to AWS console → EC2 → your instance → Tags tab
# 2. Manually DELETE the "ManagedBy" tag
# 3. Come back to terminal and run:

terraform plan
```

Terraform will show the tag as a change it wants to make.
That is drift — real world does not match state.
Do NOT apply. Just observe how Terraform detects it.

---

## Step 11 — Practice state mv (rename without destroy)

```bash
# Step 1 — move in state first
terraform state mv aws_instance.server aws_instance.web

# Step 2 — rename the resource block in main.tf to match
# change:  resource "aws_instance" "server"
# to:      resource "aws_instance" "web"

# Step 3 — verify no destroy happens
terraform plan
# Must show: No changes.
```

> If you rename in main.tf but forget state mv — Terraform will
> destroy the old one and create a new one. Always do state mv first.

---

## Step 12 — Practice state rm and re-import

```bash
# Remove from state — S3 bucket stays alive in AWS
terraform state rm aws_s3_bucket.my_bucket

# Verify it is gone from tracking
terraform state list

# Re-import it back
terraform import aws_s3_bucket.my_bucket my-manual-bucket-12345

# Verify plan is clean
terraform plan
```

---

## Step 13 — Explore State Commands

```bash
# List all resources currently tracked
terraform state list

# See full details of one resource
terraform state show aws_instance.web

# Pull raw state as JSON (useful for debugging)
terraform state pull
```

---

## Step 14 — Clean Up

```bash
terraform destroy
```

---

## How to Find AWS Resource Values

When you need to write a resource block for something that already exists:

### Option 1 — AWS Console
Go to the resource page and read values directly.
For EC2: Instance ID, AMI ID, Instance type, Subnet ID, Security groups are all on the instance detail page.

### Option 2 — AWS CLI
```bash
# EC2
aws ec2 describe-instances --instance-ids i-xxxxxxxxx

# Security Group
aws ec2 describe-security-groups --group-ids sg-xxxxxxxxx

# S3
aws s3api get-bucket-location --bucket my-manual-bucket-12345
```

### Option 3 — Write minimal block, import, let plan guide you
Write only required fields, import, run plan.
Terraform shows exactly what is different.
Add those values, run plan again. Repeat until zero changes.

---

## Golden Rules of State

| Command | State | AWS Resource |
|---|---|---|
| `terraform state rm` | removed | stays alive |
| `terraform destroy` | removed | deleted |
| `terraform import` | added | already exists |
| `terraform state mv` | renamed | untouched |

> Never edit the .tfstate file manually.
> Always use CLI commands.
> State file is the source of truth — treat it carefully.

---

## Common Mistakes

| Mistake | What Happens |
|---|---|
| Import before writing resource block | Terraform errors immediately |
| Resource block does not match AWS | Plan shows unwanted changes after import |
| Confusing state rm with destroy | Real resources get deleted accidentally |
| Renaming block without state mv first | Terraform destroys old and creates new |
| Forgetting to run plan after import | You miss drift or mismatched attributes |

---

## AWS CLI Commands Quick Reference

```bash
# Find your AMI ID for a running instance
aws ec2 describe-instances \
  --instance-ids i-xxxxxxxxx \
  --query "Reservations[0].Instances[0].ImageId" \
  --output text

# Find your VPC ID
aws ec2 describe-vpcs --query "Vpcs[*].{ID:VpcId,CIDR:CidrBlock}" --output table

# Find all security groups in a VPC
aws ec2 describe-security-groups \
  --filters "Name=vpc-id,Values=vpc-xxxxxxxxx" \
  --query "SecurityGroups[*].{ID:GroupId,Name:GroupName}" \
  --output table
```

---

## Progress Tracker

| Day | Project | Status |
|---|---|---|
| Day 1 | S3 + DynamoDB + EC2 | ✅ Done |
| Day 2 | Project Structure + VPC | ✅ Done |
| Day 3 | Variables, Validation, Locals | ✅ Done |
| Day 4 | State Operations | 🔄 Today |
| Day 5 | Data Sources + Locals deep dive | ⏳ Next |

