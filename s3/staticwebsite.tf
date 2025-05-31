terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region_name
}

provider "tls" {
  # Configuration options
}

variable "region_name" {
  type        = string
  default = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket for static website hosting"
  type        = string
}

resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "StaticWebsite"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.static_site.arn}/*"
    }]
  })
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.static_site.id
  key    = "index.html"
  content = <<EOF
<!DOCTYPE html>
<html>
<head>
  <title>Welcome</title>
</head>
<body>
  <h1>Hello from your static S3 website!</h1>
</body>
</html>
EOF

  content_type = "text/html"
#  acl          = "public-read"
}

output "s3-web" {
  value = aws_s3_bucket.static_site.id
}
output "s3-web-url" {
  value = "${aws_s3_bucket.static_site.bucket}.s3-website-${var.region_name}.amazonaws.com"
}
