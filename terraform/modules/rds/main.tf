module "databases" {
  source                = "environment"
  db_subnet_group       = "${var.rds_subnet_group}"
  db_security_groups_id = "${aws_security_group.rds.id}"
  environment           = "${var.environment}"
  cluster_name          = "${var.cluster_name}"
}

#
# AWS Security Group for RDS
#
resource "aws_security_group" "rds" {
  name   = "${var.cluster_name}_${var.environment}_rds_sg"
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
}
