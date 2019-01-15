terraform {
  required_version = "~> 0.10"
  backend "s3"{}
}


module "vpc" {
  source = "modules/vpc"
  environment = "${var.environment}"
  vpc = "${var.vpc}"
  cluster_name = "${var.cluster_name}"
  public_subnets = "${var.public_subnets}"
  private_subnets = "${var.private_subnets}"
}
