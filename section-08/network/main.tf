

module "vpc" {
  source = "./module/net"

}



resource "aws_instance" "inst02" {
  subnet_id = module.net.public_subnet_id # from output file /module/net/output.tf
}
