
terraform {
  required_version = "~> 0.15.0"
}

resource "aws_instance" "t2-micro-inst" {
  # count                  = 3
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${data.aws_security_group.ssh.id}"]
  key_name               = aws_key_pair.key.key_name
  subnet_id              = data.aws_subnet.main-public-1.id
  tags = {
    Name = "hashi-corp-terraform-inst-ec2-01"
    # Name = "hashi-corp-terraform-inst-ec2-${count.index}"
  }

}

resource "aws_key_pair" "key" {
  key_name   = "key-pub"
  public_key = file("../.secret/key.pub")
}
