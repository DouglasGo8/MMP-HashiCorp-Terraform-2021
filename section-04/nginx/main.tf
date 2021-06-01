
terraform {
  required_version = "~> 0.15.0"
}

resource "aws_instance" "nginx-inst-ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.SG_SSH_WEB
  key_name               = aws_key_pair.key.key_name
  subnet_id              = data.aws_subnet.main-public-1.id
  availability_zone      = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "EC2_NGINX_INST"
  }

  provisioner "file" {
    source      = "./installNginx.sh"
    destination = "/tmp/installNginx.sh"
  }

  # provisioner "local-exec" {
  #  command = "echo aws_instance.nginx-inst-ec2.private_ip >> priv_ips.dat"
  # }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installNginx.sh",
      "sudo sed -i -e 's/\r$//' /tmp/installNginx.sh",
      "sudo /tmp/installNginx.sh",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.EC2_INST_USER_NAME
    private_key = file("../../.secret/key.pem")
  }

}

resource "aws_key_pair" "key" {
  key_name   = "key-pub"
  public_key = file("../../.secret/key.pub")
}
