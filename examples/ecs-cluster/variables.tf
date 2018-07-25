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

variable "ssh_key_file_ecs" {
  default = "generated/id_rsa.pub"
}

variable "tags" {
  type = "map"
  default = {}
}