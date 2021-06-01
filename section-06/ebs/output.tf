output "instance" {
  value = "${aws_instance.t2-micro-inst.public_ip}"
}