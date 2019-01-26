variable "vpn_admin_user" {
  default = "openvpn"
}
variable "vpn_admin_password" {
  default = "openvpn"
}
variable "instance_type" {
  description = "instance type of the vpn server"
  default = "t3.micro"
}
variable "subnet_id" {
  description = "id of the subnet where the vpn will be deploy"
}
variable "vpc_id" {
  description = "id of the vpc where the vpn will be deploy"
}