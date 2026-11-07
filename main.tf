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
  bucket_prefix = "jazlyn-activity-bucket"
  tags = {
    Purpose = "github-actions-workshop"
  }
}