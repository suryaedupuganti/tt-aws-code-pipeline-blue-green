variable "public_subnet_ids" {
  type = list(string)
}

variable "default_tags" {
  type = map(string)
}

variable "default_prefix" {
  type = string

}
