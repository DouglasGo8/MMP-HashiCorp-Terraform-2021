variable "AWS_REGION" {
  default = "sa-east-1"
}

variable "AWS_PROFILE" {
  default = "default"
}

# Project wide variable
variable "PROJECT_NAME" {}

# VPC Variables
variable "VPC_CIDR_BLOCK" {}

# Public
variable "VPC_PUBLIC_SUBNET1_CIDR_BLOCK" {}
variable "VPC_PUBLIC_SUBNET2_CIDR_BLOCK" {}
variable "VPC_PUBLIC_SUBNET3_CIDR_BLOCK" {}

# Private
variable "VPC_PRIVATE_SUBNET1_CIDR_BLOCK" {}
variable "VPC_PRIVATE_SUBNET2_CIDR_BLOCK" {}
variable "VPC_PRIVATE_SUBNET3_CIDR_BLOCK" {}
