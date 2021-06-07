
data "aws_security_group" "ssh" {
  id = var.SG_SSH
}

data "aws_subnet" "private01" {
  id = "id-for-subnet-private-1"
}
