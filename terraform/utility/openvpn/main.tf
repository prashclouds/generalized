resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn-key"
  public_key = "${tls_private_key.key.public_key_openssh}"
}

data "aws_ami" "openvpn" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn-ami-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
}

# OpenVPN Instance
resource "aws_instance" "openvpn" {
  tags {
    Name = "openvpn"
  }

  ami                         = "${data.aws_ami.openvpn.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.openvpn.key_name}"
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = ["${aws_security_group.openvpn.id}"]
  associate_public_ip_address = true

  # `admin_user` and `admin_pw` need to be passed in to the appliance through `user_data`, see docs -->
  # https://docs.openvpn.net/how-to-tutorialsguides/virtual-platforms/amazon-ec2-appliance-ami-quick-start-guide/
  user_data = <<USERDATA
vpn_admin_user=${var.vpn_admin_user}
vpn_admin_pw=${var.vpn_admin_password}
USERDATA
}

# Elastic Ip
resource "aws_eip" "vpn_ip" {
  instance = "${aws_instance.openvpn.id}"
  vpc      = true
}