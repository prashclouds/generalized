variable "bucket_name" {
  type        = "map"
  description = "Map of AWS VPC settings"

  default = "unitq-terraform-development"
}

variable "requester_vpc_key" {
  type    = "string"
  default = "backend-braulio.tfstate"
}
