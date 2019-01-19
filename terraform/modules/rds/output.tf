# output "db_id" {
#   value = "${aws_db_instance.db.id}"
# }

# output "db_host" {
#   value = "${aws_db_instance.db.address}"
# }

# output "rds_instance" {
#   sensitive = true
#   value = {
#     DB_HOST = "${aws_db_instance.db.address}"
#     # DB_USER = "${var.database["username"]}"
#     # DB_PASS = "${var.database["password"]}"
#     DB_PORT = "${aws_db_instance.db.port}"
#   }
# }
