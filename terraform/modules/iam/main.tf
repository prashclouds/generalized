#
# MLSERVICE ROLE
#
resource "aws_iam_role" "mlservice_role" {
  name = "${var.environment}_mlservice_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.kubernetes_worker_arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "mlservice_aws_attachment" {
  count       = "${length(var.mlservice_managed_policies)}"
  role        = "${aws_iam_role.mlservice_role.name}"
  policy_arn  = "arn:aws:iam::aws:policy/${var.mlservice_managed_policies[count.index]}"
}
resource "aws_iam_role_policy" "mlservice_role_policy" {
  name   = "${var.environment}_mlservice_role_policy"
  role   = "${aws_iam_role.mlservice_role.name}"
  policy = "${data.aws_iam_policy_document.kinesis_policy.json}"
}

#
# SEARCH SERVICE ROLE
#
resource "aws_iam_role" "searchservice_role" {
  name = "${var.environment}_searchservice_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.kubernetes_worker_arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "searchservice_aws_attachment" {
  count       = "${length(var.searchservice_managed_policies)}"
  role        = "${aws_iam_role.searchservice_role.name}"
  policy_arn  = "arn:aws:iam::aws:policy/${var.searchservice_managed_policies[count.index]}"
}

#
# WSBACKEND SERVICE ROLE
#
resource "aws_iam_role" "wsbackend_role" {
  name = "${var.environment}_wsbackend_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.kubernetes_worker_arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "wsbackend_aws_attachment" {
  count       = "${length(var.wsbackend_managed_policies)}"
  role        = "${aws_iam_role.wsbackend_role.name}"
  policy_arn  = "arn:aws:iam::aws:policy/${var.wsbackend_managed_policies[count.index]}"
}
resource "aws_iam_role_policy" "wsbackend_role_policy" {
  name   = "${var.environment}_wsbackend_role_policy"
  role   = "${aws_iam_role.wsbackend_role.name}"
  policy = "${data.aws_iam_policy_document.kinesis_policy.json}"
}

#
# REVIEW SERVICE ROLE
#
resource "aws_iam_role" "reviewservice_role" {
  name = "${var.environment}_reviewservice_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.kubernetes_worker_arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "reviewservice_aws_attachment" {
  count       = "${length(var.reviewservice_managed_policies)}"
  role        = "${aws_iam_role.reviewservice_role.name}"
  policy_arn  = "arn:aws:iam::aws:policy/${var.reviewservice_managed_policies[count.index]}"
}
resource "aws_iam_role_policy" "reviewservice_role_policy" {
  name   = "${var.environment}_reviewservice_role_policy"
  role   = "${aws_iam_role.reviewservice_role.name}"
  policy = "${data.aws_iam_policy_document.kinesis_policy.json}"
}


data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "kinesis_policy" {
  statement {
      effect  = "Allow"
      actions = [
          "kinesis:*",
      ]
      resources = ["arn:aws:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/${var.environment}*"]
  }
}
