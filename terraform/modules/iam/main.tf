#
# MLSERVICE ROLE
#
resource "aws_iam_role" "mlservice_role" {
  name = "${var.environment}-mlservice-role"
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
  name   = "mlservice_role_policy"
  role   = "${aws_iam_role.mlservice_role.name}"
  policy = "${data.aws_iam_policy_document.mlservice_policy.json}"
}
data "aws_iam_policy_document" "mlservice_policy" {
  statement {
      effect  = "Allow"
      actions = [
          "kinesis:*",
      ]
      resources = ["arn:aws:kinesis:${data.aws_region.name}:${data.aws_caller_identity.current.account_id}:stream/${var.environment}*"]
  }
}

#
# SEARCH SERVICE ROLE
#
resource "aws_iam_role" "searchservice_role" {
  name = "${var.environment}-searchservice-role"
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

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}