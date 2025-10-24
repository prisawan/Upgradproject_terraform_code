terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.16.0"
    }
  }
  
   backend "s3" {
    bucket = "task1backend"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  #configuration options
  region = "us-east-1"
}
