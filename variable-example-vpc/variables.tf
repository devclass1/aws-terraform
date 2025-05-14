variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.20.0.0/16"
}

variable "app_subnet_cidr" {
  description = "CIDR block for the App subnet"
  type        = string
  default     = "172.20.10.0/24"
}

variable "work_subnet_cidr" {
  description = "CIDR block for the Work subnet"
  type        = string
  default     = "172.20.20.0/24"
}
