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
variable "roleARN" {}
variable "worker" {
  type = "map"
}
locals{
 vpc_to_connect ={
    id = "${data.terraform_remote_state.utility.vpc_id}"
    cidr = 
  }
}
