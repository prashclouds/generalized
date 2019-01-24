#create kinesis streams
module "kinesis" {
  source              = "environment"
  shard_count         = "${var.shard_count}"
  retention_period    = "${var.retention_period}"
  environment         = "${var.environment}"
}
