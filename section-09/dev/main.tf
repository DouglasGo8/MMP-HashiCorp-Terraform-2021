
module "dev-vpc" {
  source = "../modules/vpc"
  ENV    = var.env
}

module "dev-inst" {
  source = "../modules/ec2"
  VPC_ID = module.dev-vpc.my_vpc_id # from output vpc module

}
