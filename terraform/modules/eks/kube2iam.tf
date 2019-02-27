data "template_file" "kube2iam" {
  template = "${file("${path.module}/templates/kube2iam.yaml.tpl")}"
    vars {
    account_id        = "${data.aws_caller_identity.current.account_id}"
    kube2iam_version  = "${var.kube2iam_version}"
  }
}
resource "local_file" "kube2iam" {
  content  = "${data.template_file.kube2iam.rendered}"
  filename = "dist/1.kube2iam_${aws_eks_cluster.k8s.name}-${timestamp()}.yaml"
}
