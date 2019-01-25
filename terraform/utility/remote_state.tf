# The config of each environment must match with the variables of the backend config files from the ../config folder

data "terraform_remote_state" "qa" {
  backend = "s3"
  config ={
    bucket  = "unitq-terraform-development"
    key     = "backend-qa.tfstate"
    encrypt = true
    region  = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

data "terraform_remote_state" "prod" {
  backend = "s3"
  config ={
    bucket  = "unitq-terraform-development"
    key     = "backend-prod.tfstate"
    encrypt = true
    region  = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}