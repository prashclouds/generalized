output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnets_ids" {
  value = [
    "${aws_subnet.public_subnets.*.id}",
  ]
}

output "private_subnets_ids" {
  value = [
    "${aws_subnet.private_subnets.*.id}",
  ]
}

output "rds_subnet_group" {
  value = ["${aws_db_subnet_group.rds.*.name}"]
}

output "es_subnet_group" {
  value = ["${aws_elasticache_subnet_group.elasticache.*.name}"]
}