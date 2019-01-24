output "kubeconfig" {
  value = "${local.kubeconfig}"
}

output "kubeconfig_admin" {
  value = "${local.kubeconfig_admin}"
}

output "kubernetes_worker_arn" {
  value = "${aws_iam_role.eks_worker_role.arn}"
}

output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}
