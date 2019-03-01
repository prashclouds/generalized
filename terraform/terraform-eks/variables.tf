variable "region" {
  type = "string"
  description = "aws region"
}

variable "environment" {}

variable "cluster_name" {}

### VPC MODULE
variable "vpc" {
   type = "map"
}

variable "public_subnets" {
   type = "list"
}

variable "private_subnets" {
   type = "list"
}

variable "rds_subnets" {
  type = "list"
  default = []
}

### EKS MODULE
variable "worker" {
  type = "map"
}