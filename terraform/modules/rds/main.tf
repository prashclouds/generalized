resource "aws_db_instance" "db" {
  count                     = "${length(keys(var.databases))}"
  identifier                = "${element(keys(var.databases), count.index)}-${var.cluster_name}-${var.environment}"
  allocated_storage         = "${element(split(",",element(values(var.databases), count.index)), 0)}"
  storage_type              = "${element(split(",",element(values(var.databases), count.index)), 1)}"
  engine                    = "${element(split(",",element(values(var.databases), count.index)), 2)}"
  engine_version            = "${element(split(",",element(values(var.databases), count.index)), 3)}"
  instance_class            = "${element(split(",",element(values(var.databases), count.index)), 4)}"
  username                  = "${element(split(",",element(values(var.databases), count.index)), 7)}"
  password                  = "${element(split(",",element(values(var.databases), count.index)), 8)}"
  storage_encrypted         = "${element(split(",",element(values(var.databases), count.index)), 5)}"
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  db_subnet_group_name      = "${aws_db_subnet_group.rds_subnet_group.name}"
  backup_retention_period   = 1
  final_snapshot_identifier = "${element(keys(var.databases), count.index)}-${var.cluster_name}-${var.environment}-${uuid()}-latest"
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


