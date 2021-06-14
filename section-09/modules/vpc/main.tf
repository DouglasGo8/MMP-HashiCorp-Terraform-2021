module "my_main_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-${var.ENV}"
  cidr = "10.0.0.0/16"

  azs                = []
  private_subnets    = []
  public_subnets     = []
  enable_nat_gateway = true
  enable_vpn_gateway = true
  tags = {

  }

}

output "my_vpc_id" {
  description = "foo"
  value       = module.my_main_vpc_id
}

# return a list
output "my_vpc_private_subnets" {
  description = "privite sub nets"
  value       = module.my_main_vpc.private_subnets
}
