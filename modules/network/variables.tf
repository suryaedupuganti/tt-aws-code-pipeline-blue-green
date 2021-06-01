variable "cidr_block" {
  type    = string
  default = ""
}

variable "vpc_name" {
  type    = string
  default = ""
}

variable "private_subnet_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "public_subnet_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "default_prefix" {
  type    = string
  default = ""
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "availability_zones" {
  type    = list(string)
  default = []
}
