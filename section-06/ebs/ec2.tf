
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
    Name = "inst-ec201"
    # Name = "hashi-corp-terraform-inst-ec2-${count.index}"
  }
}

resource "aws_ebs_volume" "ebs-one" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 50
  type              = "gp2"
  tags = {
    Name = "Secondary Fixed Volume"
  }
}

resource "aws_volume_attachment" "ebs-attach-vol-one" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs-one.id
  instance_id = aws_instance.t2-micro-inst.id
}

resource "aws_key_pair" "key" {
  key_name   = "key-pub"
  public_key = file("../../.secret/key.pub")
}
