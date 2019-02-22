terraform {
  required_version = "~> 0.10"
  backend "s3"{
    bucket = "bryan.recinos"
    region = "us-east-1"
    key    = "backend.tfstate"
  }
}
provider "aws" {
	 version = "~> 1.56"
	 region = "${var.region}"
}
provider "local" {
	 version = "~> 1.1"
}