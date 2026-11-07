
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0"
    }
  }

  backend "s3" {
    bucket = "sctp-tfstate-ce13"
    key    = "jazlyn/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "workshop" {
  #checkov:skip=CKV_AWS_18:Access logging is configured separately
  #checkov:skip=CKV_AWS_144:Cross-region replication not required
  #checkov:skip=CKV2_AWS_62:Event notifications not required

  bucket_prefix = "jazlyn-activity-bucket"

  tags = {
    Purpose = "github-actions-workshop"
  }
}

resource "aws_s3_bucket_versioning" "workshop" {
  bucket = aws_s3_bucket.workshop.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "workshop" {
  bucket = aws_s3_bucket.workshop.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "workshop" {
  bucket = aws_s3_bucket.workshop.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "workshop" {
  bucket = aws_s3_bucket.workshop.id

  rule {
    id     = "abort-incomplete-uploads"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
