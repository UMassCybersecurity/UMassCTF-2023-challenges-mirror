resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet
  map_public_ip_on_launch = true

  tags = {
    Name    = local.subnet_name
    Purpose = local.purpose
  }
}

resource "aws_route_table_association" "route_table_association" {
  route_table_id = var.route_table_id
  subnet_id      = aws_subnet.subnet.id
}