
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 3.21" # Optional but recommended in production
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0.0"
    }
  }
}


provider "aws" {
  region  = var.aws_region
  profile = "default"
}