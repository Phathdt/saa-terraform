provider "aws" {
  region = "ap-southeast-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "web-server-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "web-server-subnet"
  }
}

resource "aws_subnet" "internal-api-subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "interal-api-subnet"
  }
}

resource "aws_subnet" "db-subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "db-subnet"
  }
}

resource "aws_subnet" "saa-subnet-nat" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "saa-subnet-nat"
  }
}

resource "aws_eip" "nat-gw" {
  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name = "eip-nat-gw"
  }
}

resource "aws_nat_gateway" "saa-nat-gw" {
  allocation_id = aws_eip.nat-gw.id
  subnet_id     = aws_subnet.saa-subnet-nat.id

  tags = {
    Name = "saa-nat-gw"
  }
}

