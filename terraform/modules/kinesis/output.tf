output "kinesis_arns" {
  value = ["${aws_kinesis_stream.kinesis-stream.*.arn}"]
}

output "kinesis_stream" {
  value = "${aws_kinesis_stream.kinesis-stream.name}"
}
