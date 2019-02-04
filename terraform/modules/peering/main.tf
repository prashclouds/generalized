
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
