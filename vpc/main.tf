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

resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.VPC_PUBLIC_SUBNET1_CIDR_BLOCK
  # AWS Resource Search
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.VPC_PUBLIC_SUBNET2_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-public-subnet-2"
  }
}

resource "aws_subnet" "public-subnet-3" {
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

resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.VPC_PRIVATE_SUBNET1_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.VPC_PRIVATE_SUBNET2_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-private-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-3" {
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

######################################################
# Elastic IP for Nat Gateway ** Spensive Resource ** #
######################################################

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet-gateway-1]
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-nat-elastic-ip"
  }
}

resource "aws_nat_gateway" "nat-gateway-1" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-subnet-1.id
  depends_on    = [aws_internet_gateway.internet-gateway-1]
  tags = {
    Name = "${var.PROJECT_NAME}-vpc-nat-gateway"
  }
}


#################################
# Route Table for Public Subnets  
#################################

resource "aws_route_table" "route-table-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway-1.id
  }

  tags = {
    Name = "${var.PROJECT_NAME}-public-route-table"
  }
}

##################################
# Route Table for Private Subnets  
##################################

resource "aws_route_table" "route-table-private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway-1.id
  }

  tags = {
    Name = "${var.PROJECT_NAME}-private-route-table"
  }
}


##############################################
# Route Table association with public subnets  
##############################################

resource "aws_route_table_association" "route-table-assoc-public-subnet-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.route-table-public.id
}

resource "aws_route_table_association" "route-table-assoc-public-subnet-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.route-table-public.id
}

resource "aws_route_table_association" "route-table-assoc-public-subnet-3" {
  subnet_id      = aws_subnet.public-subnet-3.id
  route_table_id = aws_route_table.route-table-public.id
}

##############################################
# Route Table association with private subnets  
##############################################

resource "aws_route_table_association" "route-table-assoc-private-subnet-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.route-table-private.id
}

resource "aws_route_table_association" "route-table-assoc-private-subnet-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.route-table-private.id
}

resource "aws_route_table_association" "route-table-assoc-private-subnet-3" {
  subnet_id      = aws_subnet.private-subnet-3.id
  route_table_id = aws_route_table.route-table-private.id
}

#########################################
# Security Group to allow SSH Connection
#########################################

resource "aws_security_group" "security-group-1" {

  vpc_id = aws_vpc.main.id

  name = "security-group-1"

  description = "Security Group for Public access by SSH"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-group-1"
  }
}

#########################################
# Security Group to allow Web Connection
#########################################

resource "aws_security_group" "security-group-2" {

  vpc_id = aws_vpc.main.id

  name = "security-group-2"

  description = "Security Group for Public access by Web"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-group-2"
  }
}

