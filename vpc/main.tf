terraform {
  required_version = "~> 0.15.0"
}

resource "aws_vpc" "main" {
  cidr_block           = var.VPC_CIDR_BLOCK
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  tags = {
    Name = "${var.PROJECT_NAME}"
  }
}

#################
# Public Subnets
#################

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.VPC_PUBLIC_SUBNET1_CIDR_BLOCK
  # AWS Resource Search
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.VPC_PUBLIC_SUBNET2_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-public-subnet-2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.VPC_PUBLIC_SUBNET3_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-public-subnet-3"
  }
}

###################
# Private Subnets
###################

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.VPC_PRIVATE_SUBNET1_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.VPC_PRIVATE_SUBNET2_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-private-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.VPC_PRIVATE_SUBNET3_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-private-subnet-3"
  }
}

###################
# Internet Gateway
###################

resource "aws_internet_gateway" "internet-gateway-1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-internet-gateway"
  }
}

#############################
# Elastic IP for Nat Gateway
#############################

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet-gateway-1]
}

resource "aws_nat_gateway" "main-nat-gateway-1" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.main-public-1.id
  depends_on    = ["aws_internet_gateway.internet-gateway-1"]
}

