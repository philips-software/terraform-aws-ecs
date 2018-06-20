variable "vpc_id" {}
variable "public_subnets" {}
variable "ecs_service_role_name" {}
variable "cluster_id" {}

variable "aws_region" {}

variable "environment" {}

variable "service_name" {}

variable "alb_port" {
  default = "80"
}

variable "alb_protocol" {
  default = "HTTP"
}

variable "container_port" {
  default = "80"
}

variable "container_cpu" {
  default = ""
}

variable "container_memory" {
  default = ""
}

variable "container_memory_reservation" {
  default = ""
}

variable "image_url" {
  default = "npalm/040code.github.io:latest"
}
