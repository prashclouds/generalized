module "databases" {
  # source = "environment/prod/databases.tf"
  source = "environment"
  db_subnet_group = "${aws_db_subnet_group.rds_subnet_group.name}"
  db_security_groups_id = "${aws_security_group.rds.id}"
  environment = "${var.environment}"
  cluster_name = "${var.cluster_name}"
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
