resource "aws_subnet" "subnet1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet1
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet2
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-subnet2"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.name}-db-subnet-group-cluster"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

resource "aws_route_table_association" "route_table_association1" {
  route_table_id = var.route_table_id
  subnet_id      = aws_subnet.subnet1.id
}

resource "aws_route_table_association" "route_table_association2" {
  route_table_id = var.route_table_id
  subnet_id      = aws_subnet.subnet2.id
}

