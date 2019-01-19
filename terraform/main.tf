module "vpc" {
  source          = "modules/vpc"
  environment     = "${var.environment}"
  vpc             = "${var.vpc}"
  cluster_name    = "${var.cluster_name}"
  public_subnets  = "${var.public_subnets}"
  private_subnets = "${var.private_subnets}"
  rds_subnets     = "${var.rds_subnets}"
}

module "eks" {
  source          = "modules/eks"
  environment     = "${var.environment}"
  cluster_name    = "${var.cluster_name}"
  worker          = "${var.worker}"
  vpc_id          = "${module.vpc.vpc_id}"
  private_subnets = "${module.vpc.private_subnets_ids}"
  datadog_key     = "${var.datadog_key}"
}

module "rds" {
  source              = "modules/rds"
  environment         = "${var.environment}"
  cluster_name        = "${var.cluster_name}"
  vpc_id              = "${module.vpc.vpc_id}"
  private_subnet_ids = "${module.vpc.rds_subnets_ids}"
}