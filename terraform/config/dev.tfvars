environment   = "dev"
cluster_name  = "unitq"
region        = "us-west-2"

### VPC MODULE
vpc= {
    cidr          = "10.5.0.0/16",
    dns_hostnames = true,
    dns_support   = true,
    tenancy       = "default",
  }
public_subnets  = ["10.5.0.0/24","10.5.1.0/24"]
private_subnets = ["10.5.2.0/24","10.5.3.0/24","10.5.4.0/24"]
rds_subnets     = ["10.5.5.0/24","10.5.6.0/24"]



### EKS MODULE
roleARN = "arn:aws:iam::695292474035:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AD-EKS-Dev_e62cac11786225d8"
worker= {
  instance-type = "t3.xlarge",
  desired-size  = "3",
  min-size      = "2",
  max-size      = "4"
  key_name      = "test"
}


### IAM MODULE
searchservice_managed_policies = ["AmazonS3FullAccess","AmazonESFullAccess","CloudWatchFullAccess"]
mlservice_managed_policies     = ["CloudWatchFullAccess","AmazonDynamoDBFullAccess"]
wsbackend_managed_policies     = ["CloudWatchFullAccess","AmazonDynamoDBFullAccess"]
reviewservice_managed_policies = ["CloudWatchFullAccess"]
