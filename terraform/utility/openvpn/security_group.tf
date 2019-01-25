resource "aws_security_group" "openvpn" {
  name        = "openvpn_sg"
  description = "Allow traffic needed by openvpn"
  vpc_id      = "${var.vpc_id}"

  # ssh
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # https
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # open vpn tcp
  ingress {
    from_port   = "943"
    to_port     = "943"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # open vpn udp
  ingress {
    from_port   = "1194"
    to_port     = "1194"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}