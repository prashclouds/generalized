resource "aws_kinesis_stream" "prod_kinesis_stream" {
  count               = "${var.environment == "prod" ? 1 : 0}"
  name                = "${var.environment}-test"
  shard_count         = "48"
  retention_period    = "24"
  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags {
    Environment = "${var.environment}"
  }
}
