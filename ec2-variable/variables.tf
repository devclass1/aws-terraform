variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "Class-aem-VPC"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "Class-aem-SubNet"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "us-east-1a"
}

variable "ec2_hostname" {
  description = "Hostname for the EC2 instance"
  type        = string
  default     = "Class-aem-EC2"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0953476d60561c955" # Amazon Linux 2 (us-east-1)
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

# variable "key_pair_name" {
#   description = "Name of the key pair"
#   type        = string
# }

variable "storage_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 8
}
# variable "public_key" {
#   description = "Public key material"
#   type        = string
# }
