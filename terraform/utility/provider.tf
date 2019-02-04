terraform {
  required_version = "~> 0.10"
  backend "s3"{}
}
provider "aws" {
	 version = "~> 1.56"
	 region = "${var.region}"
}