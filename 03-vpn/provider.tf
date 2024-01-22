terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }  
  }
  backend "s3" {
    bucket = "mvaws-state-dev"
    key    = "vpn"
    region = "us-east-1"
    dynamodb_table = "locking-dev"
  }
}



# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

