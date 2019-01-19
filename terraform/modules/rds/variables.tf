variable "database" {
  type        = "map"
  description = "Database settings"
  default = {
    db1 = "10,gp2,mysql,8.0.11,db.t2.micro,true,1,abc123**,user"
    db2 = "10,gp2,mysql,8.0.11,db.t2.micro,true,1,abc123**,user"
    db3 = "10,gp2,mysql,8.0.11,db.t2.micro,true,1,abc123**,user"
  }
  # default = [{
  #     identifier              = "test"
  #     allocated_storage       = 10
  #     storage_type            = "gp2"
  #     engine                  = "mysql"
  #     engine_version          = "8.0.11"
  #     instance_class          = "db.t2.medium"
  #     storage_encrypted       = true
  #     backup_retention_period = 1
  #     password                = "abc123**"
  #     username                = "user"      
  #   },
  #   {
  #     identifier              = "test3"
  #     allocated_storage       = 10
  #     storage_type            = "gp2"
  #     engine                  = "mysql"
  #     engine_version          = "8.0.11"
  #     instance_class          = "db.t2.medium"
  #     storage_encrypted       = true
  #     backup_retention_period = 1
  #     password                = "abc123**"
  #     username                = "user"      
  #   }
  # ]
}
variable "cluster_name" {
  default = "unitq"
}
variable "environment" {
  default = "dev"
}
variable "vpc_id" {}
variable "private_subnet_ids" {
  type    = "list"
}
