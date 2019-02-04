module "databases" {
  source                = "environment"
  db_subnet_group       = "${var.rds_subnet_group}"
  db_security_groups_id = "${aws_security_group.rds.id}"
  environment           = "${var.environment}"
  cluster_name          = "${var.cluster_name}"
  param_prefix          = "${var.param_prefix}"
  passwords             = "${local.passwords}"
}
#
# RDS passwords
#
data "aws_ssm_parameter" "db1_password" {
  name = "${var.param_prefix}/${var.environment}/test-password"
}
locals{
  passwords ={
    db1 = "${data.aws_ssm_parameter.db1_password.value}"
  }
}
#
# AWS Security Group for RDS
#
resource "aws_security_group" "rds" {
  name   = "${var.environment}_${var.cluster_name}_rds_sg"
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

