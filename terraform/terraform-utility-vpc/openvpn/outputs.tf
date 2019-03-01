output "vpn_sg" {
  value = "${aws_security_group.openvpn.id}"
}