resource "aws_security_group" "allow-ssh" {
  vpc_id = var.VPC_ID
}

resource "aws_instance" "my_instance" {
  subnet_id = element(var.PUBLIC_SUBNETS, 0)
}
