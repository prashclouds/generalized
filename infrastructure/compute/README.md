# ECS Cluster

* [Parameters](#parameters)
* [ECS](#ecs)
* [AutoScaling](#autoscaling)

## Parameters

* **DesiredCapacity**: Desired capacity for the auto scaling group, count of EC2 instances.
* **MaxSize**: Maximum count of instances of cluster.
* **InstanceType**: EC2 Instance type for cluster.
* **ECSSubnets**: List of subnets to distribute cluster.
* **VpcId**: VPC identifier.
* **LoadBalancerSecurityGroup**: Security group of load balancer
* **KeyPair**: Key Pair Name for EC2 access.
* **ClusterName**: Name of cluster.
* **ECSAMI**: AMI for ECS.

## ECS
Amazon Elastic Container Service (Amazon ECS) is a highly scalable, high-performance container orchestration service that supports Docker containers and allows you to easily run and scale containerized applications on AWS. Amazon ECS eliminates the need for you to install and operate your own container orchestration software, manage and scale a cluster of virtual machines, or schedule containers on those virtual machines.

**This template is invoked from `master.yml` file.**

* ECS cluster
* ECS IAM Role
* ECS instance profile
* ECS Security group for EC2 instances.

## AutoScaling
AWS Auto Scaling monitors your applications and automatically adjusts capacity to maintain steady, predictable performance at the lowest possible cost. Using AWS Auto Scaling, it’s easy to setup application scaling for multiple resources across multiple services in minutes.

* AutoScaling Group
* Launch Configuration
