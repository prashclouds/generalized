variable "vpc" {
  type        = "map"
  description = "Map of AWS VPC settings"

  default = {
    cidr          = "192.168.100.0/24"
    dns_hostnames = true
    dns_support   = true
    tag           = ""
    tenancy       = "default"
  }
}

variable "environment" {
  type    = "string"
  default = "dev"
}

variable "cluster-name" {
  type    = "string"
  default = "unitq"
}

variable "public_subnets" {
  type        = "map"
  description = "Map of AWS availability zones (key) to subnet CIDR (value) assignments"

  default = {
    us-east-1a = "192.168.100.0/27"
    #us-east-1b = "192.168.100.128/27"
  }
}

variable "private_subnets" {
  type        = "map"
  description = "Map of AWS availability zones (key) to subnet CIDR (value) assignments"

  default = {
    us-east-1a = "192.168.100.32/27"
    us-east-1b = "192.168.100.64/27"
    us-east-1c = "192.168.100.96/27"
  }
}

