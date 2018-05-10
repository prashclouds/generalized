variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "aws_az" {
    description = "Availability Zone"
    default = "us-east-1a"
}

variable "aws_web_instance_type" {
    description = "Web Instance Type"
    default = "t2.micro"
}

variable "aws_db_instance_type" {
    description = "DB Instance Type"
    default = "t2.micro"
}

variable "aws_nat_instance_type" {
    description = "NAT Instance Type"
    default = "t2.micro"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-1 = "ami-43a15f3e" # ubuntu 16.04 LTS
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}
