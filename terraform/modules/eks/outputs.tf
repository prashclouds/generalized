output "kubernetes_worker_arn" {
  value = "${aws_iam_role.eks_worker_role.arn}"
}