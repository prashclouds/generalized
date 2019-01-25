resource "aws_elasticsearch_domain" "prod_es" {
  count = "${var.environment == "prod" ? 1 : 0}"
  domain_name = "dominio1"
  elasticsearch_version = "6.3"

  cluster_config {
      instance_type = "r4.large.elasticsearch"
  }

  vpc_options {
      subnet_ids = "${var.private_subnets_ids}"
      security_group_ids = ["${var.es_sg.id}"
      ]
  }
  ebs_options {
      ebs_enabled = true
      volume_size = 10
  }
}
