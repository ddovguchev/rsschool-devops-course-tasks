output "networking" {
  value = {
    vpns : module.vpc_creator.vpc
    private-subnets : module.vpc_creator.private_subnets
    public-subnets : module.vpc_creator.public_subnets
  }
}

output "servers_info" {
  value = module.ec2_creator.instances_info
}

# output "nat-gw" {
#   value = {
#     id: module.nat_gateway.nat_gateway_id
#     public_ip : module.nat_gateway.nat_gateway_ip
#   }
# }
