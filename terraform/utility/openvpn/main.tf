resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn-key"
  public_key = "${openvpn.key.pub}"
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
  subnet_id                   = "${aws_subnet.vpn_subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.openvpn.id}"]
  associate_public_ip_address = true

  # `admin_user` and `admin_pw` need to be passed in to the appliance through `user_data`, see docs -->
  # https://docs.openvpn.net/how-to-tutorialsguides/virtual-platforms/amazon-ec2-appliance-ami-quick-start-guide/
  user_data = <<USERDATA
vpn_admin_user=${var.admin_user}
vpn_admin_pw=${var.admin_password}
USERDATA
}

# Elastic Ip
resource "aws_eip" "vpn_ip" {
  instance = "${aws_instance.openvpn.id}"
  vpc      = true
}