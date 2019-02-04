environment   = "qa"
cluster_name  = "unitq"
region        = "us-east-1"

### VPC MODULE
vpc= {
    cidr          = "10.2.0.0/16",
    dns_hostnames = true,
    dns_support   = true,
    tenancy       = "default",
  }
public_subnets  = ["10.2.0.0/16","10.2.1.0/16"]
private_subnets = ["10.2.2.0/16","10.2.3.0/16","10.2.4.0/16"]
rds_subnets     = {}

### EKS MODULE
roleARN = "arn:aws:iam::695292474035:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AD-EKS-Dev_e62cac11786225d8"
worker= {
  instance-type = "t3.xlarge",
  desired-size  = "3",
  min-size      = "2",
  max-size      = "4"
  key_name      = "test.pem"
}


### IAM MODULE
searchservice_managed_policies =  ["AmazonS3FullAccess","AmazonESFullAccess","CloudWatchFullAccess"]
mlservice_managed_policies     =  ["CloudWatchFullAccess","AmazonDynamoDBFullAccess"]
