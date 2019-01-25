############ Create a ElasticSearch Domain in qa
############ Definition of ES domain starts here
resource "aws_elasticsearch_domain" "qa_es" {
  count = "${var.environment == "qa" ? 1 : 0}"
  domain_name = "dominio2"
  elasticsearch_version = "6.3"
  cluster_config {
      instance_type = "r4.large.elasticsearch"
      instance_count                 = 1
  }
  vpc_options {
      subnet_ids = ["${var.private_subnets}"]
      security_group_ids = ["${var.es_security_groups_id}"]
  }
  ebs_options {
      ebs_enabled = "true"
      volume_size = "10"
      volume_type = "gp2"
  }
  snapshot_options {
    automated_snapshot_start_hour = "12"
  }
  tags {
    Environment = "${var.environment}"
    Cluster     = "${var.cluster_name}"
  }

  }
  ############ Definition of ES domain ends here.
