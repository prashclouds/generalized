module "vpc" {
  source          = "../modules/vpc"
  environment     = "${var.environment}"
  vpc             = "${var.vpc}"
  cluster_name    = "${var.cluster_name}"
  public_subnets  = "${local.public_subnets}"
  private_subnets = "${local.private_subnets}"
  vpcs_to_connect = "${local.vpcs_to_connect}"
}
