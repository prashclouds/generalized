variable "environment" {
  type    = "string"
  default = "dev"
}

variable "cluster_name" {
  type    = "string"
  default = "unitq"
}

# see https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html for the ami for each aws-region
variable "k8s_version" {
  type = "string"
  description = "k8s version"
  default = "1.11"
}
variable "worker" {
  type    = "map"
  description = "Map of EKS workers settings"
  default = {
    instance-type = "t3.xlarge"
    desired-size  = "2"
    min-size      = "2"
    max-size      = "4"
    key_name      = "test"
  }
}

variable "datadog_key" {
  type = "string"
  description = "API Key of the datadog agent"
  default = ""
}

variable "vpc_id" {
  type = "string"
  description = "Id of the vpc where the cluster will be deploy"
}

variable "private_subnets" {
  type = "list"
  description = "list of private subnets where the cluster will be deploy"
}
variable "public_subnets" {
  type = "list"
  description = "list of private subnets where the cluster will be deploy"
}

variable "roleARN" {
  type = "string"
  description = "Role ARN to authenticate to the cluster"
  default = ""
}
