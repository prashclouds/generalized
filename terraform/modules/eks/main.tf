# this will create K8s cluster master and will also create
# all the necessary IAM roles required by K8s master nodes

# create an IAM role that will be used by the K8s master
resource "aws_iam_role" "eks_master_role" {
  name = "eks_master_role_k8s_${var.environment}_${var.cluster_name}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# lets attach all the policies that K8s master nodes needs to manage all aws resources
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks_master_role.name}"
  depends_on = ["aws_iam_role.eks_master_role"]
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks_master_role.name}"
  depends_on = ["aws_iam_role.eks_master_role"]
}


# security group for the master nodes
resource "aws_security_group" "k8s_master_security_group" {
  name        = "k8s_master_sg_${var.environment}_${var.cluster_name}"
  description = "Allows K8s Master communication to the worker nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
    k8s-cluster = "${var.environment}_${var.cluster_name}"
  }
}

resource "aws_security_group_rule" "k8s_worker_ingress_master" {
  description              = "Allow worker Kubelets and pods to receive communication from the master control plane"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.k8s_worker_security_group.id}"
  source_security_group_id = "${aws_security_group.k8s_master_security_group.id}"
  type                     = "ingress"
}

resource "aws_security_group_rule" "k8s-master-ingress-worker" {
  description              = "Allow workers to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.k8s_master_security_group.id}"
  source_security_group_id = "${aws_security_group.k8s_worker_security_group.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "k8s-worker-ingress-ControlPlane" {
  description              = "Allow workers to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.k8s_worker_security_group.id}"
  source_security_group_id = "${aws_security_group.k8s_master_security_group.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_eks_cluster" "k8s" {
  name     = "${var.environment}_${var.cluster_name}"
  role_arn = "${aws_iam_role.eks_master_role.arn}"
  version  = "${var.k8s_version}"
  vpc_config {
    security_group_ids = ["${aws_security_group.k8s_master_security_group.id}"]
    subnet_ids         = ["${concat(var.public_subnets,var.private_subnets)}"]
  }
  depends_on = [
    "aws_iam_role.eks_master_role",
    "aws_security_group.k8s_master_security_group",
    "aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks-AmazonEKSServicePolicy",
  ]
}

locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.k8s.endpoint}
    certificate-authority-data: ${aws_eks_cluster.k8s.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: heptio-authenticator-aws
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.k8s.name}"
        - "-r"
        - "${var.roleARN}"
KUBECONFIG
}

locals {
  kubeconfig_admin = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.k8s.endpoint}
    certificate-authority-data: ${aws_eks_cluster.k8s.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.k8s.name}"
KUBECONFIG
}
