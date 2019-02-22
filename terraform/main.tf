module "vpc" {
  source          = "modules/vpc"
  environment     = "${var.environment}"
  vpc             = "${var.vpc}"
  cluster_name    = "${var.cluster_name}"
  public_subnets  = "${var.public_subnets}"
  private_subnets = "${var.private_subnets}"
  rds_subnets     = "${var.rds_subnets}"
 // vpc_to_connect = "${local.vpc_to_connect}"
}

module "eks" {
  source          = "modules/eks"
  environment     = "${var.environment}"
  cluster_name    = "${var.cluster_name}"
  worker          = "${var.worker}"
  vpc_id          = "${module.vpc.vpc_id}"
  //vpn_sg          = "${local.vpc_to_connect["vpn_sg"]}"
  private_subnets = "${module.vpc.private_subnets_ids}"
  public_subnets  = "${module.vpc.public_subnets_ids}"
}

# module "rds" {
#   source              = "modules/rds"
#   environment         = "${var.environment}"
#   cluster_name        = "${var.cluster_name}"
#   vpc_id              = "${module.vpc.vpc_id}"
#   rds_subnet_group    = "${module.vpc.rds_subnet_group[0]}"
#   param_prefix        = "${var.param_prefix}"
# }

# module "kinesis" {
#   source              = "modules/kinesis"
#   environment         = "${var.environment}"
# }