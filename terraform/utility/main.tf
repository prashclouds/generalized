module "vpc" {
  source          = "../modules/vpc"
  environment     = "${var.environment}"
  vpc             = "${var.vpc}"
  cluster_name    = "${var.cluster_name}"
  public_subnets  = "${local.public_subnets}"
  private_subnets = "${local.private_subnets}"
}

module "openvpn" {
  source    = "openvpn"
  vpc_id    = "${module.vpc.vpc_id}"
  subnet_id = "${module.vpc.public_subnets_ids[0]}"
  key_name  = "${var.key_name}"
}