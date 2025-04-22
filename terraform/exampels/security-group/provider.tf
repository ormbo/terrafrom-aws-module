terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.6"
    }
  }
backend "s3" {
    bucket  = "bucket-for-tfstate-orb"
    key     = "state/terraform-modules.tfstate"
    region  = "us-east-1"
  }
 }
provider "aws" {
  region = "us-east-1"
}