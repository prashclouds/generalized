output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}
output "vpc_cidr" {
  value = "${module.vpc.vpc_cidr}"
}
output "private_route_table" {
  value = "${module.vpc.private_route_table}"
}
output "public_route_table" {
  value = "${module.vpc.public_route_table}"
}
output "vpn_sg" {
  value = "${module.openvpn.vpn_sg}"
}