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
     "Name", "${var.environment}-${var.cluster-name}-vpc",
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
     "Name", "${var.environment}-${var.cluster-name}-public-${count.index}"
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
     "Name", "${var.environment}-${var.cluster-name}-private-${count.index}",
    )
  }"

}

#
# AWS IGW setup
#
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.environment}-${var.cluster-name}-igw"
  }
}

#
# AWS Nat Gateway setyp
# Used for the private subnets
resource "aws_eip" "nat_gw" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat_gw.id}"
  subnet_id     = "${aws_subnet.public_subnets.0.id}"
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
    Name = "${var.environment}-${var.cluster-name}-private"
  }
}

resource "aws_route_table_association" "private_subnet" {
  count          = "${length(keys(var.private_subnets))}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}



