variable "region" {
  type = "string"
  description = "aws region"
  default = "us-east-1"
}

variable "param_prefix" {
  type = "string"
  description = "Prefix of parameter store where the secrets will be retrieved"
  default = "/unitq"
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