variable "environment" {
  description = "Name of environment (i.e. dev, test, prod)"
  default = "" 
}
variable "stream_name" {
  type = "string"
  description = "Name of the stream"
  default = "test"
}
variable "shard_count" {
  description = "The number of shards that the stream will use."
  default = ""
}
variable "retention_period" {
  description = "Length of time data records are accessible after they are added to the stream."
  default     = "24"
  //  The maximum value of a stream's retention period is 168 hours. Minimum value is 24."
}