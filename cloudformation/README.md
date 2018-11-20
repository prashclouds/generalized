# General infrastructure
* This folder contains the cfn templates to create a basic infrastructure with ECS.
* You can choose between fargante and ec2 solution for your cluster.
* It has integration with datadog.
* It deploys a ECR per service.
* If you want a new service, you need to define the task definition in the /application folder creating a new file for it.
* We have a utility VPC which just has 1 public subnet and an OpenVPN server from the marketplace.
