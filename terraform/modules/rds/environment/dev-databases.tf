resource "aws_db_instance" "db_dev" {
  count                     = "${var.environment == "dev" ? 1 : 0}"
  identifier                = "${var.environment}-test",
  allocated_storage         = 10,
  storage_type              = "gp2",
  engine                    = "mysql",
  engine_version            = "8.0.11",
  instance_class            = "db.t2.micro",
  multi_az                  = false,
  storage_encrypted         = false,
  backup_retention_period   = 1,
  password                  = "${aws_ssm_parameter.db_dev_password.value}",
  username                  = "user",
  vpc_security_group_ids    = ["${var.db_security_groups_id}"]
  db_subnet_group_name      = "${var.db_subnet_group}"
  final_snapshot_identifier = "${var.environment}-${var.cluster_name}-latest"
  parameter_group_name      = "utf-8-encoding"
}

data "aws_ssm_parameter" "db_dev_password" {
  name = "${var.param_prefix}/${var.environment}/test-password"
}