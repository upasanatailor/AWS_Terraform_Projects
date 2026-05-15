# Day 5 — Dynamic Infrastructure with Terraform Data Sources & Locals

## Overview

Managing infrastructure with hardcoded values creates long-term maintenance problems.

Every time AWS releases a new Amazon Linux AMI, teams must manually update AMI IDs across multiple Terraform projects. Similarly, hardcoded VPC IDs, subnet IDs, and inconsistent naming conventions make infrastructure difficult to scale and maintain.

This project solves those problems by building a **fully dynamic Terraform configuration** using:

- **Data Sources** → Automatically discover AWS resources
- **Locals** → Standardize naming and reusable values
- **Terraform Functions** → Generate deployment timestamps automatically
- **Consistent Tagging Strategy** → Improve resource management and traceability

The result is an EC2 deployment with **zero hardcoded infrastructure values**.

---

# Problem Statement

The goal was to eliminate manual infrastructure updates and enforce consistency across all Terraform resources.

### Requirements

✅ Automatically fetch the latest **Amazon Linux 2023 AMI**  
✅ Fetch existing **VPC** dynamically using tags  
✅ Fetch existing **Subnets** dynamically using tags  
✅ Standardize resource names using **locals**  
✅ Auto-generate deployment timestamp using `timestamp()` and `formatdate()`  
✅ Apply mandatory tags to every resource:

- `Name`
- `Environment`
- `App`
- `ManagedBy`
- `DeployedAt`

✅ Launch an EC2 instance using only **data sources + locals**  
✅ No hardcoded values anywhere in `main.tf`

---

# Project Structure

```bash
.
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
└── README.md
```

---

# Terraform Concepts Used

## 1. Data Source for Latest Amazon Linux 2023 AMI

Instead of hardcoding an AMI ID, Terraform dynamically fetches the latest available image from AWS.

### Benefits

- No manual AMI updates
- Always uses latest Amazon Linux release(I had used here Ubuntu, In case of linux you can follow these steps)
- Prevents outdated machine images

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }
}
```

---

## 2. Data Source for Existing VPC

Fetches the existing VPC using tags instead of hardcoding a VPC ID.

```hcl
data "aws_vpc" "existing_vpc" {
  tags = {
    Name = "dev-vpc"
  }
}
```

### Benefits

- Avoids hardcoded VPC IDs
- More reusable across environments

---

## 3. Data Source for Existing Subnets

Automatically retrieves existing subnets by tag.

```hcl
data "aws_subnets" "existing_subnets" {
  filter {
    name   = "tag:Environment"
    values = ["dev"]
  }
}
```

### Benefits

- Dynamic subnet discovery
- Easier scaling

---

## 4. Locals for Naming Convention

A centralized naming strategy ensures every resource follows the same pattern.

```hcl
locals {
  app         = "myapp"
  environment = "dev"

  resource_name = "${local.environment}-${local.app}-ec2"
}
```

### Naming Convention

```bash
dev-myapp-ec2
```

### Benefits

- Consistency across team
- Easier resource identification
- Cleaner Terraform code

---

## 5. Auto-generated Deployment Timestamp

Terraform automatically generates deployment timestamps.

```hcl
locals {
  deployed_at = formatdate(
    "YYYY-MM-DD hh:mm:ss",
    timestamp()
  )
}
```

### Example Tag

```bash
DeployedAt = 2026-05-15 14:22:30
```

### Benefits

- Track deployment history
- Useful for auditing

---

## 6. Standardized Resource Tags

All resources include consistent tags.

```hcl
locals {
  common_tags = {
    Name        = local.resource_name
    Environment = local.environment
    App         = local.app
    ManagedBy   = "Terraform"
    DeployedAt  = local.deployed_at
  }
}
```

---

# EC2 Instance Deployment

The EC2 instance uses only dynamic values.

```hcl
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnets.existing_subnets.ids[0]

  tags = local.common_tags
}
```

---

# Validation

Run Terraform plan:

```bash
terraform init
terraform plan
```

Terraform resolves the latest AMI automatically:

```bash
ami = "ami-xxxxxxxxxxxxxxxxx"
```

No AMI IDs or subnet IDs are manually entered anywhere.

---

# Key Learning Outcomes

This project demonstrates practical experience with:

- Terraform Data Sources
- Dynamic Infrastructure Discovery
- Terraform Locals
- Naming Standardization
- Tag Management
- Terraform Functions
- AWS EC2
- AWS VPC
- AWS Subnet Lookup
- Infrastructure as Code Best Practices

---

# Why This Matters

Dynamic Terraform configurations are easier to maintain, safer to scale, and reduce human error.

By eliminating hardcoded values and enforcing naming standards, infrastructure becomes:

- More reusable
- More automated
- Easier for teams to manage
- Production-ready

---

## Tech Stack

- Terraform
- AWS EC2
- AWS VPC
- AWS Subnets
- IAM
- Amazon Linux 2023

---

## Author

**Upasana Tailor**  
DevOps Engineer | Cloud & Automation Enthusiast

---