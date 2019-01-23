#create kinesis streams

resource "aws_kinesis_stream" "kinesis-stream" {
  name        = "${var.environment}-${var.stream_name}"
  shard_count = "${var.shard_count}"
  retention_period    = "${var.retention_period}"
  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags {
    Name        = "${var.environment}-${var.stream_name}"
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
  }
}
