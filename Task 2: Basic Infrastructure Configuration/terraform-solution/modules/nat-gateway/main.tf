resource "aws_eip" "main" {
  tags = {
    Name = "${var.name_prefix}-ngw-ip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "${var.name_prefix}-ngw"
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.name_prefix}-rtb-ngw"
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}