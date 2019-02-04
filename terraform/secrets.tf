## Secrets retrieved from AWS parameter store
data "aws_ssm_parameter" "datadog_key" {
  name = "${var.param_prefix}/${var.environment}/datadog_key"
}
