resource "aws_db_instance" "db" {
  count                     = "${length(var.databases)}"
  identifier                = "${lookup(var.databases[count.index],"identifier")}-${var.cluster_name}-${var.environment}"
  allocated_storage         = "${lookup(var.databases[count.index],"allocated_storage")}"
  storage_type              = "${lookup(var.databases[count.index],"storage_type")}"
  engine                    = "${lookup(var.databases[count.index],"engine")}"
  engine_version            = "${lookup(var.databases[count.index],"engine_version")}"
  instance_class            = "${lookup(var.databases[count.index],"instance_class")}"
  multi_az                  = "${lookup(var.databases[count.index],"multi_az")}"
  username                  = "${lookup(var.databases[count.index],"username")}"
  password                  = "${lookup(var.databases[count.index],"password")}"
  storage_encrypted         = "${lookup(var.databases[count.index],"storage_encrypted")}"
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  db_subnet_group_name      = "${aws_db_subnet_group.rds_subnet_group.name}"
  backup_retention_period   = "${lookup(var.databases[count.index],"backup_retention_period")}"
  final_snapshot_identifier = "${lookup(var.databases[count.index],"identifier")}-${var.cluster_name}-${var.environment}-${uuid()}-latest"
}


#
# AWS Subnet Group for RDS
#
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.environment}-${var.cluster_name}-rds-subnet-group"
  subnet_ids = ["${var.private_subnet_ids}"]

  tags = {
    Name = "${var.environment}-${var.cluster_name}-rds-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name   = "${var.cluster_name}-${var.environment}-rds-sg"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Environment = "${var.environment}"
  }
}


