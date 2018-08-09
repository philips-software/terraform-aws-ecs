variable "aws_region" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "project" {
  description = "Project identifier"
  type        = "string"
}

variable "key_name" {
  type = "string"
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "public_key_file" {
  default = "generated/id_rsa.pub"
}

variable "private_key_file" {
  default = "generated/id_rsa"
}
