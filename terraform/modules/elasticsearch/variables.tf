variable "cluster_name" {
  default = "unitq"
}
variable "environment" {
  default = "dev"
}
variable "vpc_id" {}
variable "private_subnets" {
  type    = "list"
}