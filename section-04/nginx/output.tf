output "instance" {
  value = "${aws_instance.nginx-inst-ec2.public_ip}"
}