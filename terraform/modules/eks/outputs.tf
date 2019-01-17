output "kubeconfig" {
  value = "${local.kubeconfig}"
}

output "kubeconfig-admin" {
  value = "${local.kubeconfig-admin}"
}

output "config-map-aws-auth" {
  value = "${local.config-map-aws-auth}"
}
