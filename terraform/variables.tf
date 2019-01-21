variable "region" {
  type = "string"
  description = "aws region"
  default = "us-east-1"
}

variable "datadog_key" {
  type = "string"
  description = "API Key of the datadog agent"
  default = "test"
}

variable "environment" {}
variable "cluster_name" {}

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
variable "worker" {
  type = "map"
}