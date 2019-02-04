#
# AWS VPC setup
#
data "aws_availability_zones" "available" {}
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc["cidr"]}"
  enable_dns_hostnames = "${var.vpc["dns_hostnames"]}"
  enable_dns_support   = "${var.vpc["dns_support"]}"
  instance_tenancy     = "${var.vpc["tenancy"]}"

  tags = "${
    map(
     "Name", "${var.environment}_${var.cluster_name}_vpc",
     "kubernetes.io/cluster/${var.environment}_${var.cluster_name}","shared"
    )
  }"
}

#
# AWS Subnets setup
#
locals{
  private_subnets_count = "${length(var.private_subnets) + length(keys(var.elasticache_subnets)) + length(keys(var.rds_subnets))}"
}
resource "aws_subnet" "public_subnets" {
  count                   = "${length(var.public_subnets)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))}"
  cidr_block              = "${var.public_subnets[count.index]}"
  map_public_ip_on_launch = true
  tags = "${
    map(
     "Name", "${var.environment}_${var.cluster_name}_public_${count.index}",
     "kubernetes.io/cluster/${var.environment}_${var.cluster_name}","shared"
    )
  }"
}

resource "aws_subnet" "private_subnets" {
  count                   = "${length(var.private_subnets)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))}"
  cidr_block              = "${var.private_subnets[count.index]}"
  map_public_ip_on_launch = false
  tags = "${
    map(
     "Name", "${var.environment}_${var.cluster_name}_private_${count.index}",
     "kubernetes.io/cluster/${var.environment}_${var.cluster_name}","shared"
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
}

#
# AWS Nat Gateway setup
# Used for the private subnets
resource "aws_eip" "nat_gw" {
  count       = "${local.private_subnets_count> 0 ? 1 :0}"
  vpc         = true
  depends_on  = ["aws_subnet.private_subnets"]
}

resource "aws_nat_gateway" "nat_gw" {
  count         = "${local.private_subnets_count > 0 ? 1 : 0}"
  allocation_id = "${aws_eip.nat_gw.0.id}"
  subnet_id     = "${aws_subnet.public_subnets.0.id}"
  tags = {
    Name = "${var.environment}_${var.cluster_name}_nat"
  }
  depends_on = ["aws_subnet.private_subnets","aws_subnet.public_subnets"]
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
  count  = "${local.private_subnets_count > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw.0.id}"
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
resource "aws_route_table" "rds_route_table" {
  count  = "${length(keys(var.rds_subnets)) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw.0.id}"
  }
  tags {
    Name = "${var.environment}_${var.cluster_name}_private_rds_route"
  }
}
resource "aws_route_table" "elasticache" {
  count = "${length(keys(var.elasticache_subnets)) > 0 ? 1 : 0}"
  vpc_id = "${local.vpc_id}"
  tags {
    Name = "${var.environment}_${var.cluster_name}_es_route"
  }
}
resource "aws_route_table" "elasticache_route_table" {
  count  = "${length(keys(var.elasticache_subnets)) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw.0.id}"
  }
  tags {
    Name = "${var.environment}_${var.cluster_name}_private_elasticache_route"
  }
}
resource "aws_route_table_association" "private_subnet" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.0.id}"
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
  count         = "${length(var.vpc_to_connect)}"
  peer_vpc_id   = "${var.vpc_to_connect["vpc_id"]}"
  vpc_id        = "${aws_vpc.vpc.id}"
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
    Name = "${var.environment}_${var.cluster_name}_peering_${var.vpc_to_connect["vpc_id"]}"
  }
}

resource "aws_route" "route_peering_public" {
  count                     = "${length(var.vpc_to_connect)}"
  route_table_id            = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block    = "${var.vpc_to_connect["vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.0.id}"
  depends_on                = ["aws_vpc.vpc","aws_vpc_peering_connection.peering"]
}

