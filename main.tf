terraform {
  backend "s3" {
    bucket       = "sctp-tfstate-ce13"
    key          = "jazlyn/terraform.tfstate"
    region       = "us-east-1"
  }
}

provider "aws" {
   region = "us-east-1"
}

resource "aws_s3_bucket" "workshop" {
  bucket_prefix = "jazlyn-activity-bucket"
  tags = {
    Purpose = "github-actions-workshop"
  }
}