terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
backend "s3" {
    bucket  = "dwh-bi-state-s3"
    key     = "terraform-state/terraform.tfstate"
    region  = "us-east-1"
  }
 }
provider "aws" {
  region = "us-east-1"
}