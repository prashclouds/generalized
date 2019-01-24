output "kubeconfig" {
  value = "${local.kubeconfig}"
}

output "kubeconfig-admin" {
  value = "${local.kubeconfig-admin}"
}

output "kubernetes_worker_arn" {
  value = "${aws_iam_role.eks-worker-role.arn}"
}

output "config-map-aws-auth" {
  value = "${local.config-map-aws-auth}"
}
