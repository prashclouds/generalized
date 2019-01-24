variable "environment" {
  type = "string"
  default= "dev"
}

variable "kubernetes_worker_arn" {
  type = "string"
  default=""
}

variable "kinesis_arns" {
   type = "list"
   default = ["*"]
}

variable "searchservice_managed_policies" {
  type = "list"
  description = "List of aws managed policies to associate to the role"
  default = ["AmazonS3FullAccess","AmazonESFullAccess","CloudWatchFullAccess"]
}

variable "mlservice_managed_policies" {
  type = "list"
  description = "List of aws managed policies to associate to the role"
  default = ["CloudWatchFullAccess","AmazonDynamoDBFullAccess"]
}