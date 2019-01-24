variable "region" {
  type = "string"
  description = "aws region"
}

variable "param_prefix" {
  type = "string"
  description = "Prefix of parameter store where the secrets will be retrieved"
  default = "/unitq"
}
variable "environment" {}

#EKS cluster name
variable "cluster_name" {}

#kinesis stream
variable "shard_count" {}
variable "retention_period" {}

### VPC MODULE
variable "vpc" {
   type = "map"
}

variable "public_subnets" {
   type = "map"
}

variable "private_subnets" {
   type = "map"
}

variable "rds_subnets" {
  type = "map"
}

### EKS MODULE
variable "roleARN" {}
variable "worker" {
  type = "map"
}
