module "es_clusters" {
  # source = "environment/prod/databases.tf"
  source = "environment"
  private_subnet_ids = "${var.private_subnets}"
  es_security_groups_id = "${aws_security_group.es_sg.id}"
  environment = "${var.environment}"
  cluster_name = "${var.cluster_name}"
}

### Elastic Search security groups ###

resource "aws_security_group" "es_sg" {
  name = "${var.environment}-${var.cluster_name}-es-sg"
  description = "Allow inbound traffic to ElasticSearch from VPC CIDR"
  vpc_id = "${var.vpc}"
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Environment = "${var.environment}"
  }
}
