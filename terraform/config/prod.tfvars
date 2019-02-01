environment="prod"
cluster_name="unitq"
region="us-east-1"

### VPC Module
vpc= {
    cidr          = "192.168.100.0/24",
    dns_hostnames = true,
    dns_support   = true,
    tag           = "",
    tenancy       = "default",
  }
public_subnets = { us-east-1a = "192.168.100.0/28"}
private_subnets = { us-east-1a = "192.168.100.32/28", us-east-1b = "192.168.100.64/28"}
rds_subnets = { us-east-1a = "192.168.100.96/28", us-east-1b = "192.168.100.128/28"}

### EKS MODULE
roleARN = "arn:aws:iam::619993530046:role/UnitQEKSUser"
worker= {
  instance-type = "m4.2xlarge",
  desired-size  = "4",
  min-size      = "4",
  max-size      = "8"
  key_name      = "test.pem"
}



### IAM Module
searchservice_managed_policies =  ["AmazonS3FullAccess","AmazonESFullAccess","CloudWatchFullAccess"]
mlservice_managed_policies     =  ["CloudWatchFullAccess","AmazonDynamoDBFullAccess"]