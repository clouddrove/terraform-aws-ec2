output "instance_id" {
  value = "${aws_instance.main.id}"
}

output "az" {
  value = "${aws_instance.main.availability_zone}"
}
