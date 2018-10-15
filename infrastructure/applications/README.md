# Services

* [ALB](#loadbalancer)
* [ALBListenerRule](#listener)
* [Services](#services)

## ALB
A load balancer serves as the single point of contact for clients. The load balancer distributes incoming application traffic across multiple targets, such as EC2 instances, in multiple Availability Zones. This increases the availability of your application. You add one or more listeners to your load balancer.

Each target group routes requests to one or more registered targets, such as EC2 instances, using the protocol and port number that you specify. You can register a target with multiple target groups. You can configure health checks on a per target group basis. Health checks are performed on all targets registered to a target group that is specified in a listener rule for your load balancer.

* **This template is invoked from `master.yml` file.**
* **ContainerPort**: Port where serivce is listening.
* **ALBPort**: Port Number
* **Certificate**: SSL Certificate.
* **LoadBalancerSubnets**: Subnets where the LB is able to listen.
* **VpcId**: VPC ID.
* **ClusterName**: Name of the cluster

## ALBListenerRule
A listener checks for connection requests from clients, using the protocol and port that you configure, and forwards requests to one or more target groups, based on the rules that you define. Each rule specifies a target group, condition, and priority. When the condition is met, the traffic is forwarded to the target group. You must define a default rule for each listener, and you can add rules that specify different target groups based on the content of the request (also known as content-based routing).

**This template is invoked from `services.yml` file.**

* **Listener**: LoadBalancer ARN
* **HttpsListener**: LoadBalancer listener ARN (HTTPS)
* **Path**: Path to listen (default: \*)
* **Priority**: Priority on loadbalancer.
* **TargetGroup**: (Optional) in case there is a need of specifying a target group.


![VPC Diagram](../images/loadbalancer.png)

## Service
Amazon ECS allows you to run and maintain a specified number of instances of a task definition simultaneously in an Amazon ECS cluster. This is called a service. If any of your tasks should fail or stop for any reason, the Amazon ECS service scheduler launches another instance of your task definition to replace it and maintain the desired count of tasks in the service depending on the scheduling strategy used.

**This template is invoked from `master.yml` file.**

* **Listener**: The ALB listener
* **ImageTag**: Tag of container to launch
* **TaskCount**: Number of tasks to run in the service
* **ContainerPort**: Internal port on which the container listers
* **ContainerMemory**: Memory allocation for the container. Tasks that exceed their allocation are restarted.
* **ContainerCPU**: CPU allocation for the container. Tasks that exceed their allocation are restarted.
* **ECSCluster**: ECS Cluster to attach the service
* **ServiceName**: Used to identify task and path for load balancer rule
* **RailsECR**: ECR for rails
* **TargetGroup**: Target Group
* **VpcId**: VPC ID.
