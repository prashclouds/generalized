terraform {
  required_version = "~> 0.10"
  backend "s3"{
    bucket  = "unitq-terraform-development"
    key     = "backend-utility.tfstate"
    encrypt = true
    region  = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
	 version = "~> 1.56"
	 region = "${var.region}"
}