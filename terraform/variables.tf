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
   type = "list"
}

variable "private_subnets" {
   type = "list"
}

variable "rds_subnets" {
  type = "map"
  default = {}
}

### EKS MODULE
variable "roleARN" {}
variable "worker" {
  type = "map"
}
locals{
 vpc_to_connect ={
    vpc_id                = "${data.terraform_remote_state.utility.vpc_id}"
    vpc_cidr              = "${data.terraform_remote_state.utility.vpc_cidr}"
    public_route_table    = "${data.terraform_remote_state.utility.public_route_table}"
    private_route_table   = "${data.terraform_remote_state.utility.private_route_table}"
  }
}
