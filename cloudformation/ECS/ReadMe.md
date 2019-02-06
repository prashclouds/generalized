
# AWS ECS

Amazon Elastic Container Service (Amazon ECS) is a highly scalable, high-performance container orchestration service that supports Docker containers and allows to easily run and scale containerized applications on AWS. Amazon ECS eliminates the need for you to install and operate your own container orchestration software, manage and scale a cluster of virtual machines, or schedule containers on those virtual machines.

## Fargate
AWS Fargate is a compute engine for Amazon ECS that allows you to run containers without having to manage servers or clusters. With AWS Fargate, you no longer have to provision, configure, and scale clusters of virtual machines to run containers.

![Fargate](images/fargate.png)

To Spin up an aplication on ECS you need to define a Service and Tasks Definitions:
- A service allows you to run and maintain a specified number of instances of a task definition simultaneously in the ECS cluster
- A task definition is the way you define the docker containers that you want to run. You specify some parameters like the image, roles, and cpu and memory to use with each task.

## EC2
With ECS running on EC2 instances you are responsible of deploying the required infrastructure. You need to configure an AutoScaling Group and a Load Balancer.

![ECS](images/ecs.png)

The benefits of using ECS EC2 is that you have more control over the instances and you can make use of the spot and reserved instances option so it's less expensive than using Fargate.

## Monitorig
This templates uses different ways to monitor the application and infrastructure associated with it, following nclouds best practices.

### AWS CloudWatch
CloudWatch monitors AWS resources and applications in real time. It allows to collect and track metrics that are important to measure.

### DataDog
The agent is installed on the ECS instances allowing to send data and metrics to the DataDog server at different levels:
- Instance
- Container
- Aplication

### System Manager
![ECS](images/SSM.png)

## CloudFormation

### Parameters