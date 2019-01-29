#
# AWS VPC setup
#
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc["cidr"]}"
  enable_dns_hostnames = "${var.vpc["dns_hostnames"]}"
  enable_dns_support   = "${var.vpc["dns_support"]}"
  instance_tenancy     = "${var.vpc["tenancy"]}"

  tags = "${
    map(
     "Name", "${var.environment}_${var.cluster_name}_vpc",
    )
  }"
}

#
# AWS Subnets setup
#
resource "aws_subnet" "public_subnets" {
  count                   = "${length(keys(var.public_subnets))}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "${element(keys(var.public_subnets), count.index)}"
  cidr_block              = "${element(values(var.public_subnets), count.index)}"
  map_public_ip_on_launch = true
  tags = "${
    map(
     "Name", "${var.environment}_${var.cluster_name}_public_${count.index}"
    )
  }"
}

resource "aws_subnet" "private_subnets" {
  count                   = "${length(keys(var.private_subnets))}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "${element(keys(var.private_subnets), count.index)}"
  cidr_block              = "${element(values(var.private_subnets), count.index)}"
  map_public_ip_on_launch = false
  tags = "${
    map(
     "Name", "${var.environment}_${var.cluster_name}_private_${count.index}",
    )
  }"
}

#
# RDS subnet
#
resource "aws_subnet" "private_rds_subnets" {
  count                   = "${length(keys(var.rds_subnets))}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "${element(keys(var.rds_subnets), count.index)}"
  cidr_block              = "${element(values(var.rds_subnets), count.index)}"
  map_public_ip_on_launch = false
  tags = "${
    map(
     "Name", "${var.environment}_${var.cluster_name}_private_rds_${count.index}",
    )
  }"
}

resource "aws_db_subnet_group" "rds" {
  count      = "${length(keys(var.rds_subnets)) > 0 ? 1 : 0}"
  name       = "${var.environment}_${var.cluster_name}_rds_subnet_group"
  subnet_ids =  ["${aws_subnet.private_rds_subnets.*.id}"]
}

#
# ElastiCache subnet
#
resource "aws_subnet" "private_elasticache_subnets" {
  count = "${length(keys(var.elasticache_subnets))}"

  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "${element(keys(var.elasticache_subnets), count.index)}"
  cidr_block              = "${element(values(var.elasticache_subnets), count.index)}"
  map_public_ip_on_launch = false
  tags = "${
    map(
     "Name", "${var.environment}_${var.cluster_name}_private_es_${count.index}",
    )
  }"
}

resource "aws_elasticache_subnet_group" "elasticache" {
  count       = "${length(keys(var.elasticache_subnets)) > 0 ? 1 : 0}"
  name        = "${var.environment}_${var.cluster_name}_es_subnet_group"
  description = "ElastiCache subnet group"
  subnet_ids  = ["${aws_subnet.private_elasticache_subnets.*.id}"]
}

#
# AWS IGW setup
#
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}_${var.cluster_name}_igw"
  }
  depends_on = ["aws_subnet.public_subnets"]
}

#
# AWS Nat Gateway setup
# Used for the private subnets
resource "aws_eip" "nat_gw" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat_gw.id}"
  subnet_id     = "${aws_subnet.public_subnets.0.id}"
  tags = {
    Name = "${var.environment}_${var.cluster_name}_nat"
  }
}

#
# AWS Route Table setup
# Grant the VPC internet access on its main route table
resource "aws_route" "public_gateway" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
  }
  tags {
    Name = "${var.environment}_${var.cluster_name}_private_route"
  }
}
resource "aws_route_table" "rds" {
  count = "${length(keys(var.rds_subnets)) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}_${var.cluster_name}_rds_route"
  }
}
resource "aws_route_table" "elasticache" {
  count = "${length(keys(var.elasticache_subnets)) > 0 ? 1 : 0}"
  vpc_id = "${local.vpc_id}"
  tags {
    Name = "${var.environment}_${var.cluster_name}_es_route"
  }
}

resource "aws_route_table_association" "private_subnet" {
  count          = "${length(keys(var.private_subnets))}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "rds_subnet" {
  count          = "${length(keys(var.rds_subnets))}"
  subnet_id      = "${element(aws_subnet.private_rds_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.rds.id}"
}

resource "aws_route_table_association" "elasticache_subnet" {
  count = "${length(keys(var.elasticache_subnets))}"
  subnet_id      = "${element(aws_subnet.private_elasticache_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.elasticache.id}"
}
#
# VPC Peering connections
#

resource "aws_vpc_peering_connection" "peering" {
  count         = "${length(var.vpcs_to_connect)}"
  peer_vpc_id   = "${aws_vpc.vpc.id}"
  vpc_id        = "${var.vpcs_to_connect[count.index]}"
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution  = true
    allow_classic_link_to_remote_vpc = true
    allow_vpc_to_remote_classic_link = true
  }

  requester {
    allow_remote_vpc_dns_resolution  = true
    allow_classic_link_to_remote_vpc = true
    allow_vpc_to_remote_classic_link = true
  }
  tags = {
    Name = "${var.environment}_${var.cluster_name}_peering_${var.vpcs_to_connect[count.index]}"
  }
}

/*TODO
resource "aws_route" "route_peering" {
  route_table_id            = "rtb-4fbb3ac4"
  destination_cidr_block    = "10.0.1.0/22"
  vpc_peering_connection_id = "pcx-45ff3dc1"
  depends_on                = ["aws_route_table.testing"]
}*/