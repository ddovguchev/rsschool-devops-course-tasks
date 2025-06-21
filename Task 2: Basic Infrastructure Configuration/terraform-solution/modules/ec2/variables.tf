variable "servers_config" {
  description = "Configuration for servers"
  type = map(object({
    sg_config = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    server_config = object({
      ami               = string
      instance_type     = string
      tags              = map(string)
      subnet_id         = string
      key_name          = optional(string)
      user_data         = optional(string)
      isPublic          = bool
      source_dest_check = optional(bool)
    })
  }))
}

variable "vpc_id" {
  description = "Default VPC name"
  type        = string
}
