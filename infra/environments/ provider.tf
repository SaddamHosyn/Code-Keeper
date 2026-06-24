terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }

  backend "s3" {
    bucket  = "cloud-design-terraform-state-bucket"
    key     = "infrastructure/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-north-1"
}