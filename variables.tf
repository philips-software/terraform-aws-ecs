variable "aws_region" {
  type        = string
  description = "The Amazon region: currently North Virginia [us-east-1]."
}

variable "environment" {
  description = "Name of the environment; will be prefixed to all resources."
  type        = string
}

variable "key_name" {
  type        = string
  description = "The AWS keyname, used to create instances."
}

variable "instance_type" {
  type        = string
  description = "The instance type used in the cluster."
}

variable "vpc_id" {
  type        = string
  description = "The VPC to launch the instance in (e.g. vpc-66ecaa02)."
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC (e.g. 10.64.48.0/23)."
  type        = string
}

variable "min_instance_count" {
  type        = string
  description = "The minimal instance count in the cluster."
  default     = "1"
}

variable "max_instance_count" {
  type        = string
  description = "The maximum instance count in the cluster."
  default     = "1"
}

variable "desired_instance_count" {
  type        = string
  description = "The desired instance count in the cluster."
  default     = "1"
}

variable "dynamic_scaling" {
  type        = string
  description = "Enable/disable dynamic scaling of the auto scaling group."
  default     = "false"
}

variable "dynamic_scaling_adjustment" {
  type        = string
  description = "The adjustment in number of instances for dynamic scaling."
  default     = "1"
}

variable "subnet_ids" {
  type        = string
  description = "List of subnets ids on which the instances will be launched."
}

// http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI_launch_latest.html

variable "ecs_optimized_type" {
  description = "Possible values"
  default     = "amzn2"
}

variable "ecs_ami_filter" {
  description = "The filter used to select the AMI for the ECS cluster. By default the the pattern `amzn2-ami-ecs-hvm-2.0.????????-x86_64-ebs` for the name is used."
  type        = list(map(string))

  default = [
    {
      name   = "name"
      values = "amzn2-ami-ecs-hvm-2.0.????????-x86_64-ebs"
    },
  ]
}

variable "ecs_ami_latest" {
  description = "Indicator to use the latest avaiable in the the list of the AMI's for the ECS cluster."
  default     = true
}

variable "ecs_ami_owners" {
  description = "A list of owners used to select the AMI for the ECS cluster."
  type        = list(string)
  default     = ["amazon"]
}

variable "project" {
  description = "Project identifier"
  type        = string
}

variable "user_data" {
  description = "The user-data for the ec2 instances"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to apply on the resources"
  default     = {}
}

