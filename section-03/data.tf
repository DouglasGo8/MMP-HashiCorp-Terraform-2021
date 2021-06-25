
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = var.AMI_OWNERS # Canonical
}

data "aws_security_group" "ssh" {
  id = var.SG_SSH
}

data "aws_subnet" "main-public-1" {
  id = var.PUB_SUBNET_1
}
