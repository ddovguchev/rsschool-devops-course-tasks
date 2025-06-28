resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = "${terraform.workspace}-VPC"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets_cidr_blocks

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = var.aws_availability_zones[each.value.az]

  tags = {
    Name      = "${terraform.workspace}-private-subnet-${each.key}"
    SubnetKey = each.key
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets_cidr_blocks

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = var.aws_availability_zones[each.value.az]
  map_public_ip_on_launch = true

  tags = {
    Name      = "${terraform.workspace}-public-subnet-${each.key}"
    SubnetKey = each.key
  }
}

resource "aws_internet_gateway" "igw" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-IGW"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = {
    Name = "${terraform.workspace}-rtb-igw"
  }
}

resource "aws_route_table_association" "internet_access" {
  for_each = var.public_subnets_cidr_blocks

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.main.id
}