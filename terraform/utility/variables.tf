variable "region" {
  type = "string"
  description = "aws region"
  default = "us-west-2"
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
variable "key_name" {
  type = "string"
  description = "pem key"
  default = "test"
}
### VPC MODULE
variable "vpc" {
   type = "map"
   default = {    
    cidr          = "10.100.0.0/16",
    dns_hostnames = true,
    dns_support   = true,
    tag           = "utility",
    tenancy       = "default"
    
  }
}
locals{
  public_subnets  = ["10.100.0.0/24","10.100.1.0/24"]
  private_subnets = ["10.100.2.0/24","10.100.3.0/24"]
}