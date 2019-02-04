variable "db_subnet_group" {}
variable "db_security_groups_id" {}
variable "environment" {}
variable "cluster_name" {}
variable "param_prefix" {}
variable "passwords" {
  type = "map"
  default = {
    db1 = "abc123**"
  }
}
