terraform {
  required_version = "~> 0.10"
  backend "s3" {
    encrypt = false
  }
}


module "vpc" {
  source          = "modules/vpc"
}
