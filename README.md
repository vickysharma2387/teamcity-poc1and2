**ECS-EC2 Cluster with Terraform, S3 State Storage, and GitHub Actions:**

This repository contains Terraform code for setting up an Amazon ECS cluster with EC2 instances, using modularized Terraform configurations. The setup includes storing the Terraform state file in an S3 bucket and automating deployments through a GitHub Actions workflow.

Steps - 

Step 1: Create S3 Bucket for Terraform State
Step 2: Configure Terraform Modules
Step 3: Configure main.tf in the Root Module
Step 4: Create dev.tfvars for Environment-Specific Variables
Step 5: Set Up GitHub Actions Workflow
Step 6: Run and Verify

Usage - 
Prerequisites

1. AWS Account: With appropriate IAM permissions to create ECS clusters, EC2 instances, VPC, security groups, etc.
2. GitHub Repository: To store your code and host the GitHub Actions workflow.
3. Terraform: Installed locally if running commands manually.
4. AWS CLI: To configure AWS access locally if needed.
5. GitHub Secrets: Configure AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in your GitHub repository secrets for GitHub Actions to access AWS.

```
Project Structure

project-root/
├── main.tf                 # Root Terraform module
├── outputs.tf              # Output values for root module
├── variables.tf            # Input variables for root module
├── dev.tfvars              # Environment-specific variables for dev
├── modules/
│   ├── vpc/                # VPC module
│   ├── ecs-ec2/            # ECS-EC2 module
│   └── security_group/     # Security group module
└── .github/
    └── workflows/
        └── terraform.yml   # GitHub Actions workflow
```

Steps

Step 1: Create S3 Bucket for Terraform State

1. In the AWS Console:
Go to S3 and create a new bucket (e.g., my-terraform-state-bucket).
Enable versioning on this bucket for better state management.

2. Configure Terraform Backend:
In main.tf, add the S3 backend configuration for Terraform to store the state remotely.

```
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "ecs-cluster/terraform.tfstate"
    region = "us-west-2"  # Update with your AWS region
  }
}
```

Step 2: Configure Terraform Modules

2.1 VPC Module:
Create a VPC with public subnets and associate an Internet Gateway and route table to make it public.
Directory: modules/vpc
Files: main.tf, variables.tf, outputs.tf

2.2 ECS-EC2 Module:
Create an ECS-EC2 in the specified VPC.
Directory: modules/ecs-ec2
Files: main.tf, variables.tf, outputs.tf

2.3 Security Group Module:
Create a security group with inbound rules to allow traffic on ports 22, 80, and 3000.
Directory: modules/security_group
Files: main.tf, variables.tf, outputs.tf

2.4 ECR Module:
Create an ecr to store build docker image.
Directory: modules/ecr
Files: main.tf, variables.tf, outputs.tf

Step 3: Configure main.tf in the Root Module
In the root directory, set up main.tf to call each module, passing necessary variables. The main.tf file also includes environment tags using variables like env_name and product_name.
```
provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source     = "./modules/vpc"
  env_name   = var.env_name
  product_name = var.product_name
}

module "ecs-ec2" {
  source       = "./modules/ecs-ec2"
  instance_type = "t2.micro"
  security_groups = [module.security_group.security_group_id]
  env_name       = var.env_name
  product_name   = var.product_name
}

module "security_group" {
  source       = "./modules/security_group"
  vpc_id       = module.vpc.vpc_id
  env_name     = var.env_name
  product_name = var.product_name
}
```

Step 4: Create dev.tfvars for Environment-Specific Variables
Create a dev.tfvars file in the root directory to define environment-specific values:
```
env_name     = "dev"
product_name = "team city"
```

Step 5: Set Up GitHub Actions Workflow
In .github/workflows/terraform.yml, set up the GitHub Actions workflow to automatically apply the Terraform code on every push to the main branch.

GitHub Actions Workflow (terraform.yml)

```
name: Deploy ECS-EC2

on:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.0

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-west-2

      - name: Initialize Terraform
        run: terraform init

      - name: Plan Terraform
        run: terraform plan -var-file="dev.tfvars" -out=tfplan

      - name: Apply Terraform
        if: github.ref == 'refs/heads/main'
        run: terraform apply tfplan
```

Step 6: Run and Verify

1. Push to GitHub:
Commit and push your code to GitHub. The GitHub Actions workflow will be triggered automatically.

2. Manual Terraform Apply (Optional):
If running locally, use:
```
terraform init
terraform apply -var-file="dev.tfvars"
```

3. Verify in AWS Console:
Check ECS, EC2, VPC, and Security Groups in the AWS Console to confirm resources have been created with the correct configurations.

Usage
Modify dev.tfvars for other environments, or create a prod.tfvars for production and update the GitHub Actions workflow to handle multiple environments if needed.
This setup modularizes resources, manages state in S3, and automates deployments with GitHub Actions, making it easy to manage and deploy AWS infrastructure with Terraform.
