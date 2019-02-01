resource "aws_db_instance" "db_qa" {
  count                     = "${var.environment == "qa" ? 1 : 0}"
  identifier                = "${var.environment}-test",
  allocated_storage         = 5,
  storage_type              = "gp2",
  engine                    = "mysql",
  engine_version            = "8.0.11",
  instance_class            = "db.t2.large",
  multi_az                  = false,
  storage_encrypted         = false,
  backup_retention_period   = 1,
  password                  = "${aws_ssm_parameter.db_qa_password}",
  username                  = "user",
  vpc_security_group_ids    = ["${var.db_security_groups_id}"]
  db_subnet_group_name      = "${var.db_subnet_group}"
  final_snapshot_identifier = "${var.environment}-${var.cluster_name}-latest"
  parameter_group_name      = "utf-8-encoding"
}

data "aws_ssm_parameter" "db_qa_password" {
  name = "${var.param_prefix}/${var.environment}/test-password"
}