variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnets" {
  type = map(object({
    id = string
  }))
}

variable "name_prefix" {
  type = string
}