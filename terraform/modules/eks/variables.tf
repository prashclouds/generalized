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
variable "worker-instance-type" {
  type    = "string"
  default = "t3.large"
}

variable "worker-desired-size" {
  type    = "string"
  default = "4"
}

variable "worker-max-size" {
  type    = "string"
  default = "8"
}

variable "worker-min-size" {
  type    = "string"
  default = "4"
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