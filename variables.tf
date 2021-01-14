variable "aws_region" {
  description = "The Amazon region: currently North Virginia [us-east-1]."
  type        = string
}

variable "environment" {
  description = "Name of the environment; will be prefixed to all resources."
  type        = string
}

variable "key_name" {
  description = "The AWS keyname, used to create instances."
  type        = string
}

variable "instance_type" {
  description = "The instance type used in the cluster."
  type        = string
}

variable "vpc_id" {
  description = "The VPC to launch the instance in (e.g. vpc-66ecaa02)."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC (e.g. 10.64.48.0/23)."
  type        = string
}

variable "additional_cidr_blocks" {
  description = "Additional CIDR blocks that will be whitelisted within the VPC next to the VPC's CIDR block. Default is an empty list."
  type        = list
  default     = []
}

variable "min_instance_count" {
  description = "The minimal instance count in the cluster."
  type        = number
  default     = 1
}

variable "max_instance_count" {
  description = "The maximum instance count in the cluster."
  type        = number
  default     = 1
}

variable "desired_instance_count" {
  description = "The desired instance count in the cluster."
  type        = number
  default     = 1
}

variable "dynamic_scaling" {
  description = "Enable/disable dynamic scaling of the auto scaling group."
  type        = bool
  default     = false
}

variable "enable_session_manager" {
  description = "Enable/disable aws session manager support (i.e remote access to instance in VPC using secure tunnel)."
  type        = bool
  default     = false
}

variable "dynamic_scaling_adjustment" {
  description = "The adjustment in number of instances for dynamic scaling."
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "List of subnets ids on which the instances will be launched."
  type        = string
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
  type        = bool
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

