#create kinesis streams
module "kinesis" {
  source              = "environment"
  environment         = "${var.environment}"
}
