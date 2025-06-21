locals {
  vpc_cidr_block = "10.0.0.0/16"

  public_subnets_cidr_blocks = {
    public_1 = {
      cidr = "10.0.1.0/24"
      az   = "1"
    }
    public_2 = {
      cidr = "10.0.3.0/24"
      az   = "2"
    }
  }

  private_subnets_cidr_blocks = {
    private_1 = {
      cidr = "10.0.2.0/24"
      az   = "1"
    }
    private_2 = {
      cidr = "10.0.4.0/24"
      az   = "2"
    }
  }

  servers_config = {
    bastion_host = {
      sg_config = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["10.0.0.0/16"]
          type        = "ingress"
        },
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          type        = "egress"
        }
      ]
      server_config = {
        ami           = data.aws_ami.ubuntu.id
        instance_type = "t2.micro"
        tags = {
          "Name" = "${terraform.workspace}-bastion_host-host"
        }
        subnet_id         = module.vpc_creator.public_subnets.public_1.id
        key_name          = aws_key_pair.dd-personal.key_name
        user_data         = file("${path.module}/user_data/nat-userdata.sh")
        isPublic          = true
        source_dest_check = false
      }
    },
    private_ec2-1 = {
      sg_config = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [module.vpc_creator.public_subnets.public_1.cidr]
        }
      ]
      server_config = {
        ami           = data.aws_ami.ubuntu.id
        instance_type = "t2.micro"
        tags = {
          "Name" = "${terraform.workspace}-private_ec2-1-host",
        }
        subnet_id = module.vpc_creator.private_subnets.private_1.id
        key_name  = aws_key_pair.dd-personal.key_name
        user_data = false
        isPublic  = false
      }
    },
    private_ec2-2 = {
      sg_config = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [module.vpc_creator.public_subnets.public_1.cidr]
        }
      ]
      server_config = {
        ami           = data.aws_ami.ubuntu.id
        instance_type = "t2.micro"
        tags = {
          "Name" = "${terraform.workspace}-private_ec2-2-host",
        }
        subnet_id = module.vpc_creator.private_subnets.private_2.id
        key_name  = aws_key_pair.dd-personal.key_name
        user_data = false
        isPublic  = false
      }
    }
  }
}