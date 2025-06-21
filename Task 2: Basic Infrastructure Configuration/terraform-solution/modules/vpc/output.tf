output "vpc" {
  value = {
    id   = aws_vpc.main.id
    cidr = aws_vpc.main.cidr_block
  }
}

output "private_subnets" {
  value = { for k, v in aws_subnet.private : k => { id = v.id, cidr = v.cidr_block } }
}

output "public_subnets" {
  value = { for k, v in aws_subnet.public : k => { id = v.id, cidr = v.cidr_block } }
}
