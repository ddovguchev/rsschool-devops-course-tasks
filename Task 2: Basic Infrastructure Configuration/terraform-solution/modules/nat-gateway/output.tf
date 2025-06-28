output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}

output "nat_gateway_ip" {
  value = aws_nat_gateway.main.public_ip
}