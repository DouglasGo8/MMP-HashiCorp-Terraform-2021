

resource "aws_instance" "MyInstance" {
  ami = "ami-05692172655678b4e"
  instance_type = "t2.micro"
  tags = {
    Name = "demo-inst"
  }
}