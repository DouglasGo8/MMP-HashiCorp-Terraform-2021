
resource "aws_vpc" "webapp-vpc" {
  cidr_block           = var.WEBAPP_CIDR_BLOCK
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.ENVIRONMENT}-webapp-vpc"
  }
}

## PUBLIC SUB NETS
resource "aws_subnet" "webapp-public-subnet-01" {
  vpc_id                  = aws_vpc.webapp-vpc.id
  cidr_block              = var.WEBAPP_VPC_PUBLIC_SUBNET01_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.ENVIRONMENT}-webapp-vpc-public-subnet-01"
  }
}

resource "aws_subnet" "webapp-public-subnet-02" {
  vpc_id                  = aws_vpc.webapp-vpc.id
  cidr_block              = var.WEBAPP_VPC_PUBLIC_SUBNET02_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.ENVIRONMENT}-webapp-vpc-public-subnet-02"
  }
}

resource "aws_subnet" "webapp-private-subnet-01" {
  vpc_id            = aws_vpc.webapp-vpc.id
  cidr_block        = var.WEBAPP_VPC_PRIVATE_SUBNET01_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.ENVIRONMENT}-webapp-vpc-private-subnet-01"
  }
}

resource "aws_subnet" "webapp-private-subnet-02" {
  vpc_id            = aws_vpc.webapp-vpc.id
  cidr_block        = var.WEBAPP_VPC_PRIVATE_SUBNET02_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.ENVIRONMENT}-webapp-vpc-private-subnet-02"
  }
}

resource "aws_internet_gateway" "webapp-igw" {
  vpc_id = aws_vpc.webapp-vpc.id

  tags = {
    Name = "${var.ENVIRONMENT}-webapp-vpc-internet-gateway"
  }
}

# Expesive Resource
# ELastic IP for NAT Gateway
resource "aws_eip" "webapp-nat-eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.webapp-igw]
}

resource "aws_nat_gateway" "webapp-ngw" {
  allocation_id = aws_eip.webapp-nat-eip.id
  subnet_id     = aws_subnet.webapp-public-subnet-01.id
  depends_on    = [aws_internet_gateway.webapp-igw]
  tags = {
    Name = "${var.ENVIRONMENT}-webapp-vpc-NAT-gateway"
  }
}

# Route Table for public Architecture
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.webapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webapp-igw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-webapp-public-route-table"
  }
}

# Route table for Private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.webapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.webapp-ngw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-webapp-private-route-table"
  }
}

# Route Table association with public subnets
resource "aws_route_table_association" "to_public_subnet1" {
  subnet_id      = aws_subnet.webapp-public-subnet-01.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "to_public_subnet2" {
  subnet_id      = aws_subnet.webapp-public-subnet-02.id
  route_table_id = aws_route_table.public.id
}

# Route table association with private subnets
resource "aws_route_table_association" "to_private_subnet1" {
  subnet_id      = aws_subnet.webapp-private-subnet-01.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "to_private_subnet2" {
  subnet_id      = aws_subnet.webapp-private-subnet-02.id
  route_table_id = aws_route_table.private.id
}
