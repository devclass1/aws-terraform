provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Create S3 bucket for website hosting
resource "aws_s3_bucket" "github_sync_bucket" {
  bucket = "github-sync-bucket-${random_id.bucket_suffix.hex}" # Unique bucket name
  acl    = "private"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  force_destroy = true # Allows bucket to be destroyed even if not empty

  tags = {
    Name        = "GitHub Sync Bucket"
    Environment = "Dev"
  }
}

# Add bucket policy to make contents publicly accessible (optional)
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.github_sync_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.github_sync_bucket.arn}/*"
      }
    ]
  })
}

# Random suffix for unique bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-github-sync-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for CodeBuild
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild-github-sync-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = ["*"]
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "codecommit:GitPull"
        ]
      }
    ]
  })
}

# CodeBuild project
resource "aws_codebuild_project" "github_sync_build" {
  name          = "github-sync-build"
  description   = "Build project to sync GitHub repo to S3"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = 5

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/your-username/your-repo.git" # Replace with your GitHub repo
    git_clone_depth = 1
    buildspec       = <<EOF
version: 0.2
phases:
  build:
    commands:
      - echo "Syncing GitHub repo to S3..."
      - aws s3 sync . s3://${aws_s3_bucket.github_sync_bucket.bucket} --delete
EOF
  }
}

# CodePipeline
resource "aws_codepipeline" "github_sync_pipeline" {
  name     = "github-sync-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.github_sync_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = "your-username"          # Replace with your GitHub username
        Repo       = "your-repo"              # Replace with your GitHub repo name
        Branch     = "main"                   # Replace with your branch
        OAuthToken = var.github_token         # You'll need to create this variable
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Sync_To_S3"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.github_sync_build.name
      }
    }
  }
}

# IAM Role for CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-github-sync-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for CodePipeline
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-github-sync-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = ["*"]
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:UploadArchive",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:CancelUploadArchive"
        ]
      }
    ]
  })
}

# GitHub OAuth token variable
variable "github_token" {
  description = "GitHub OAuth token for repository access"
  type        = string
  sensitive   = true
}

output "website_url" {
  value = aws_s3_bucket.github_sync_bucket.website_endpoint
}

output "bucket_name" {
  value = aws_s3_bucket.github_sync_bucket.bucket
}
