module "vpc_creator" {
  source                      = "./modules/vpc"
  vpc_cidr_block              = local.vpc_cidr_block
  enable_dns_hostnames        = true
  enable_dns_support          = true
  public_subnets_cidr_blocks  = local.public_subnets_cidr_blocks
  private_subnets_cidr_blocks = local.private_subnets_cidr_blocks
  create_igw                  = true
  aws_availability_zones      = data.aws_availability_zones.available.names
}

module "ec2_creator" {
  source         = "./modules/ec2"
  vpc_id         = module.vpc_creator.vpc.id
  servers_config = local.servers_config
  depends_on     = [module.vpc_creator]
}

# module "nat_gateway" {
#   source           = "./modules/nat-gateway"
#   vpc_id           = module.vpc_creator.vpc.id
#   public_subnet_id = module.vpc_creator.public_subnets.public_1.id
#   private_subnets  = module.vpc_creator.private_subnets
#   name_prefix      = terraform.workspace
# }

resource "aws_key_pair" "dd-personal" {
  key_name   = "dd-personal-keypair"
  public_key = file("./ssh_keys/dd-personal-keypair.pub")
}

resource "aws_route_table" "private" {
  vpc_id = module.vpc_creator.vpc["id"]

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route" "private_nat_instance" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.ec2_creator.instances_info["bastion_host"].eni_id
}

resource "aws_route_table_association" "private" {
  for_each = { for idx, subnet in module.vpc_creator.private_subnets : idx => subnet }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}