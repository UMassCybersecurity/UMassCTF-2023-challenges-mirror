resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-internet_gateway"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.name}-route_table"
  }
}
