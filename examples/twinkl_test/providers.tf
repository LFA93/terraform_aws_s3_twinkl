terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.9.0"
}

provider "aws" {
  region     = var.region
  access_key = local.aws_keys[var.environment].access_key
  secret_key = local.aws_keys[var.environment].secret_key
}

