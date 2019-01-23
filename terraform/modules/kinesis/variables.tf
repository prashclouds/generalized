variable "project_name" {
  description = "Name of project"
}

variable "environment" {
  description = "Name of environment (i.e. dev, test, prod)"
}

variable "stream_name" {
  description = "A name to identify the stream. This is unique to the AWS account and region the Stream is created in"
}

variable "shard_count" {
  description = "The number of shards that the stream will use."
}

variable "retention_period" {
  description = "Length of time data records are accessible after they are added to the stream."
  default     = "24"
  //  The maximum value of a stream's retention period is 168 hours. Minimum value is 24."
}
