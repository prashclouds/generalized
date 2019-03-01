data "aws_ami" "openvpn" {
  most_recent = true
  filter {
    name = "name"
    values = ["OpenVPN Access Server 2.6.1*"]
  }
}

# OpenVPN Instance
resource "aws_instance" "openvpn" {
  tags {
    Name = "openvpn"
  }

  ami                         = "${data.aws_ami.openvpn.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = ["${aws_security_group.openvpn.id}"]
  associate_public_ip_address = true
  disable_api_termination     = true

  # `admin_user` and `admin_pw` need to be passed in to the appliance through `user_data`, see docs -->
  # https://docs.openvpn.net/how-to-tutorialsguides/virtual-platforms/amazon-ec2-appliance-ami-quick-start-guide/
  user_data = <<USERDATA
vpn_admin_user=${var.vpn_admin_user}
vpn_admin_pw=${var.vpn_admin_password}
USERDATA
lifecycle {
  prevent_destroy = true
}
}

# Elastic Ip
resource "aws_eip" "vpn_ip" {
  instance = "${aws_instance.openvpn.id}"
  vpc      = true
}
