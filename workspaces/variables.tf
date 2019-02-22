variable "region" {
  type = "string"
  description = "aws region"
}

### VPC MODULE
variable "vpc" {
   type = "map"
   default = {
    cidr          = "10.101.0.0/16",
    dns_hostnames = true,
    dns_support   = true,
    tenancy       = "default"
   }
}
