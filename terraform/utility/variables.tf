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
variable "environment" {
  type = "string"
  default = "utility"
}
variable "cluster_name" {
  type = "string"
  default = "unitq"
}

### VPC MODULE
variable "vpc" {
   type = "map"
   default = {    
    cidr          = "192.168.100.0/24",
    dns_hostnames = true,
    dns_support   = true,
    tag           = "utility",
    tenancy       = "default"
  }
}
locals{
  public_subnets {
    "${var.region}a" = "192.168.100.0/27"
  }
  private_subnets ={
    "${var.region}b" = "192.168.100.32/27"
  }
}