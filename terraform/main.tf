terraform {
  required_version = "~> 0.10"
  backend "s3"{}
}


module "vpc" {
  source          = "modules/vpc"
  environment = "${var.environment}"
}
