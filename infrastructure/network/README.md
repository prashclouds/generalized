# Network

* [VPC](#vpc)

## VPC
Amazon Virtual Private Cloud (Amazon VPC) lets you provision a logically isolated section of the AWS Cloud where you can launch AWS resources in a virtual network that you define. You have complete control over your virtual networking environment, including selection of your own IP address range, creation of subnets, and configuration of route tables and network gateways. You can use both IPv4 and IPv6 in your VPC for secure and easy access to resources and applications.

**This template is invoked from `master.yml` file.**

* **keyName**: Name of key
* **AvailabilityZone1**: availability zone
* **AvailabilityZone2**: availability zone
* **pubcidr1**: cidr for public subnet
* **pubcidr2**: cidr for public subnet
* **pricidr1**: cidr for private subnet
* **pricidr2**: cidr for private subnet
* **vpccidr**: cidr for VPC
* **Stackname**: name of stack
* **InstanceTenancy**: instance tenancy

* The VPC.
* 2 Private subnets in 3 availability zones.
* 2 Public subnets in 3 availability zones.
* 1 Internet gateway and its attachment.
* 1 Nat gateways and its attachment.
*   Route tables and associations.
* 1 Elastic IPs for the NAT gateways.
* Necessary access control list for each subnet.
