environment   = "qa"
cluster_name  = "unitq"
region        = "us-east-1"

### VPC MODULE
vpc= {
    cidr          = "192.168.50.0/24",
    dns_hostnames = true,
    dns_support   = true,
    tenancy       = "default",
  }
public_subnets  = {us-east-1a = "192.168.50.0/27",  us-east-1b = "192.168.50.160/27"}
private_subnets = {us-east-1a = "192.168.50.32/27", us-east-1b = "192.168.50.64/27"}
rds_subnets     = {us-east-1a = "192.168.50.96/27", us-east-1b = "192.168.50.128/27"}

### EKS MODULE
roleARN = "arn:aws:iam::695292474035:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AD-EKS-Dev_e62cac11786225d8"
worker= {
  instance-type = "t3.xlarge",
  desired-size  = "3",
  min-size      = "2",
  max-size      = "4"
}


### IAM MODULE
searchservice_managed_policies =  ["AmazonS3FullAccess","AmazonESFullAccess","CloudWatchFullAccess"]
mlservice_managed_policies     =  ["CloudWatchFullAccess","AmazonDynamoDBFullAccess"]
