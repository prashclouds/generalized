# The config of the remote state of utility musth match with the utility/config/backend-utility.conf file

# data "terraform_remote_state" "utility" {
#   backend = "s3"
#   config ={
#     bucket  = "unitq-terraform-development"
#     key     = "backend-utility.tfstate"
#     encrypt = true
#     region  = "us-east-1"
#     dynamodb_table = "terraform-lock"
#   }
# }
