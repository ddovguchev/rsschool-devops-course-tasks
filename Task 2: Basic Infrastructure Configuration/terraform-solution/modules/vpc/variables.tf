variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
}

variable "public_subnets_cidr_blocks" {
  description = "A list of CIDR blocks and az for public subnets"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets_cidr_blocks" {
  description = "A list of CIDR blocks and az for public subnets"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "create_igw" {
  description = "Set to true to create an Internet Gateway"
  type        = bool
}

variable "aws_availability_zones" {
  type = list(string)
}

