module "vpc" {
  source          = "../modules/vpc"
  environment     = "${var.environment}"
  vpc             = "${var.vpc}"
  cluster_name    = "${var.cluster_name}"
  public_subnets  = "${local.public_subnets}"
  private_subnets = "${local.private_subnets}"
  vpcs_to_connect = "${local.vpcs_to_connect}"
}

module "openvpn" {
  source = "openvpn"
  vpc_id = "${module.vpc.id}"
  subnet_id = "${module.public_subnets_ids.0}"
  
}