# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${aws_vpc.default.id}"
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${aws_subnet.us-east-1-private.id}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${aws_subnet.us-east-1-public.id}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${aws_eip.web-1.public_ip}"]
}