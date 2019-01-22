terraform {
  required_version = "~> 0.10"
  backend "s3"{}
}
provider "aws" {
	 version = "~> 1.56"
	 region = "${var.region}"
}
provider "http" {
	 version = "~> 1.0"
}
provider "null" {
	 version = "~> 1.0"
}
provider "local" {
	 version = "~> 1.1"
}
provider "template" {
	 version = "~> 1.0"
}