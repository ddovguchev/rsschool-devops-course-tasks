resource "aws_security_group" "sg" {
  for_each = var.servers_config

  name        = "${terraform.workspace}-${each.key}-sg"
  description = "Security group for ${each.key}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = each.value.sg_config
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server" {
  for_each = var.servers_config

  ami           = each.value.server_config.ami
  instance_type = each.value.server_config.instance_type
  key_name      = each.value.server_config.key_name != null ? each.value.server_config.key_name : null
  subnet_id     = each.value.server_config.subnet_id
  vpc_security_group_ids = [aws_security_group.sg[each.key].id]
  user_data     = each.value.server_config.user_data
  associate_public_ip_address = each.value.server_config.isPublic
  source_dest_check = each.value.server_config.source_dest_check != null ? each.value.server_config.source_dest_check : true

  tags = merge(
    { "Name" = each.key },
    each.value.server_config.tags
  )
}
