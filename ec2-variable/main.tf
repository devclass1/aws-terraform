# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Create Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}

# Create Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.vpc_name}-rt"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Create Security Group
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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

  tags = {
    Name = "allow_ssh_http"
  }
}

# # Create Key Pair
# resource "aws_key_pair" "deployer" {
#   key_name   = var.key_pair_name
#   public_key = var.public_key
# }

###Create KEy
resource "tls_private_key" "terraform-aws-class-key" {
  algorithm = "RSA"
  rsa_bits = "4096"
}

resource "aws_key_pair" "terraform-aem-2-pem" {
key_name = "terraform-aem-2-pem"
public_key = tls_private_key.terraform-aws-class-key.public_key_openssh

}
 resource "local_file" "ssh_key" {
     filename = "${aws_key_pair.terraform-aem-2-pem.key_name}"
     content  = tls_private_key.terraform-aws-class-key.private_key_pem
 }


# Create EC2 Instance
resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name               = aws_key_pair.terraform-aem-2-pem.id

  root_block_device {
    volume_size = var.storage_size
  }

  tags = {
    Name = var.ec2_hostname
  }
}
