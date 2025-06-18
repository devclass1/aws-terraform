# Terraform State Management and AWS Lab

## Understanding Terraform State

Terraform state is a crucial concept that tracks the resources Terraform manages. It's a JSON file (usually named `terraform.tfstate`) that maintains a mapping between the resources in your configuration and the real infrastructure in your cloud provider.

### Key Aspects of Terraform State:

1. **Resource Mapping**: Tracks which real-world resource corresponds to each resource in your configuration
2. **Metadata Storage**: Stores resource attributes and dependencies
3. **Performance**: Caches resource attributes for faster operations
4. **Collaboration**: When working in teams, state helps avoid conflicts

### Types of State:

- **Local State**: Default, stored on your local machine
- **Remote State**: Stored in a shared location (S3, Terraform Cloud, etc.)

## AWS Terraform Lab: Deploying a VPC with EC2 Instance

This lab will guide you through creating AWS infrastructure using Terraform, focusing on state management.

### Prerequisites:
- AWS account with IAM credentials
- Terraform installed
- AWS CLI configured

### Lab Steps:

#### 1. Set up your working directory
```bash
mkdir terraform-aws-lab
cd terraform-aws-lab
