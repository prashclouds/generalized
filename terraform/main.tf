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
  roleARN         = "${var.roleARN}"
  worker          = "${var.worker}"
  vpc_id          = "${module.vpc.vpc_id}"
  private_subnets = "${module.vpc.private_subnets_ids}"
  datadog_key     = "${data.aws_ssm_parameter.datadog_key.value}"
}

module "rds" {
  source              = "modules/rds"
  environment         = "${var.environment}"
  cluster_name        = "${var.cluster_name}"
  vpc_id              = "${module.vpc.vpc_id}"
  private_subnet_ids  = "${module.vpc.rds_subnets_ids}"
}

# module "elasticsearch" {
#   source              = "modules/elasticsearch"
#   environment         = "${var.environment}"
#   vpc_id              = "${module.vpc.vpc_id}"
#   private_subnet_ids  = "${module.vpc.private_subnets_ids}"
# }

module "kinesis" {
  source              = "modules/kinesis"
  environment         = "${var.environment}"
  shard_count         = "${var.shard_count}"
  retention_period    = "${var.retention_period}"
}

module "iam" {
  source                = "modules/iam"
  environment           = "${var.environment}"
  kubernetes_worker_arn = "${module.eks.kubernetes_worker_arn}"
}
