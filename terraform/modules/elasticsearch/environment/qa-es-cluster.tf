resource "aws_elasticsearch_domain" "qa_es" {
  count = "${var.environment == "qa" ? 1 : 0}"
  domain_name = "dominio2"
  elasticsearch_version = "6.3"

  cluster_config {
      instance_type = "r4.large.elasticsearch"
  }

  vpc_options {
      private_subnets = "${var.private_subnets}"
      es_security_group_ids = "${var.es_sg.id}"
  }
  ebs_options {
      ebs_enabled = true
      volume_size = 10
  }
}