environment   ="prod"
cluster_name  ="junelife"
region        ="us-west-2"

### VPC Module
vpc= {
    cidr          = "10.1.0.0/16",
    dns_hostnames = true,
    dns_support   = true,
    tenancy       = "default",
  }
public_subnets  = ["10.1.0.0/24","10.1.1.0/24"]
private_subnets = ["10.1.2.0/24","10.1.3.0/24","10.1.4.0/24"]
rds_subnets     = ["10.1.5.0/24","10.1.6.0/24"]

### EKS MODULE
worker= {
  instance-type = "m4.2xlarge",
  desired-size  = "4",
  min-size      = "4",
  max-size      = "8"
  key_name      = "test"
}
