# Create VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "myvpc"
  }
}

# App Subnet
resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.app_subnet_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "app-subnet"
  }
}

# Work Subnet
resource "aws_subnet" "work_subnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.work_subnet_cidr
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "work-subnet"
  }
}
