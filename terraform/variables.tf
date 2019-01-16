variable "region" {
  type = "string"
  description = "aws region"
  default = "us-east-1"
}

variable "environment" {}

variable "cluster_name" {}

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
