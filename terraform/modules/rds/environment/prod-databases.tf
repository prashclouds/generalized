resource "aws_db_instance" "db_prod" {
  count                   = "${var.environment == "prod" ? 1 : 0}"
  identifier              = "${var.environment}-test",
  allocated_storage       = 10,
  storage_type            = "gp2",
  engine                  = "mysql",
  engine_version          = "8.0.11",
  instance_class          = "db.t2.micro",
  multi_az                = false,
  storage_encrypted       = true,
  backup_retention_period = 1,
  password                = "abc123**",
  username                = "user",
  vpc_security_group_ids    = ["${var.db_security_groups_id}"]
  db_subnet_group_name      = "${var.db_subnet_group}"
  final_snapshot_identifier = "${var.environment}-${var.cluster_name}-latest"
}

