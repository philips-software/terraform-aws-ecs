variable "aws_region" {
  type        = "string"
  description = "The Amazon region: currently North Virginia [us-east-1]."
}

variable "environment" {
  description = "Name of the environment; will be prefixed to all resources."
  type        = "string"
}

variable "key_name" {
  type        = "string"
  description = "The AWS keyname, used to create instances."
}

variable "instance_type" {
  type        = "string"
  description = "The instance type used in the cluster."
}

variable "vpc_id" {
  type        = "string"
  description = "The VPC to launch the instance in (e.g. vpc-66ecaa02)."
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC (e.g. 10.64.48.0/23)."
  type        = "string"
}

variable "min_instance_count" {
  type        = "string"
  description = "The minimal instance count in the cluster."
  default     = "1"
}

variable "max_instance_count" {
  type        = "string"
  description = "The maximum instance count in the cluster."
  default     = "1"
}

variable "desired_instance_count" {
  type        = "string"
  description = "The desired instance count in the cluster."
  default     = "1"
}

variable "subnet_ids" {
  type        = "list"
  description = "List of subnets ids on which the instances will be launched."
}

// https://docs.aws.amazon.com/AmazonECS/latest/developerguide/al2ami-get-latest.html
variable "ecs_optimized_amis" {
  description = "List with ecs optimized images per region, last updated on: 2018-08-31 (2018.03.e)."
  type        = "map"

  default = {
    us-east-1      = "ami-0a6b7e0cc0b1f464f" # US East (N. Virginia)
    us-east-2      = "ami-037a92bf1efdb11a2" # US East (Ohio)
    us-west-1      = "ami-0184f498956de7db5" # US West (N. California)
    us-west-2      = "ami-0c1f4871ebaae6d86"          # US West (Oregon)
    ca-central-1   = "ami-02c80e9173258d289"          # Canada (Central)
    eu-west-1      = "ami-0acc9f8be17a41897" # EU (Ireland)
    eu-west-2      = "ami-0b5225210a12d9951"          # EU (London)
    eu-west-3      = "ami-0caadc4f0db31a303" # EU (Paris)
    eu-central-1   = "ami-055aa9664ef169e25" # EU (Frankfurt)
    ap-northeast-1 = "ami-0c38293d60d98af86" # Asia Pacific (Tokyo)
    ap-northeast-2 = "ami-0bdc871079baf9649" # Asia Pacific (Seoul)
    ap-southeast-1 = "ami-0e28ff4e3f1776d86" # Asia Pacific (Singapore)
    ap-southeast-2 = "ami-0eed1c915ea891aca" # Asia Pacific (Sydney)
    ap-south-1     = "ami-0b7c3be99909df6ef" # Asia Pacific (Mumbai)
    sa-east-1      = "ami-078146697425f25a7" # South America (São Paulo)
    us-gov-west-1  = "ami-31b5d150"          # GovCloud
  }
}

variable "user_data" {
  description = "The user-data for the ec2 instances"
  type        = "string"
}

variable "tags" {
  type        = "map"
  description = "Map of tags to apply on the resources"
  default     = {}
}

variable "security_group_id" {
    description = "AWS Security Group ID"
    type        = "string"
}

variable "ecs_instance_role_name" {
    description = "IAM Role name of ECS instances"
}

variable "cluster_name" {
    description = "ECS Cluster name"
}
