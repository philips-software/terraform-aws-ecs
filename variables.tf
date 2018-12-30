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
  type        = "string"
  description = "List of subnets ids on which the instances will be launched."
}

// http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI_launch_latest.html
variable "ecs_optimized_amis" {
  description = "List with ecs optimized images per region, last updated on: 2018-08-31 (2018.03.e)."
  type        = "map"

  default = {
    us-east-1      = "ami-00129b193dc81bc31" # US East (N. Virginia)
    us-east-2      = "ami-028a9de0a7e353ed9" # US East (Ohio)
    us-west-1      = "ami-0d438d09af26c9583" # US West (N. California)
    us-west-2      = "ami-00d4f478"          # US West (Oregon)
    ca-central-1   = "ami-192fa27d"          # Canada (Central)
    eu-west-1      = "ami-0af844a965e5738db" # EU (Ireland)
    eu-west-2      = "ami-a44db8c3"          # EU (London)
    eu-west-3      = "ami-07da674f0655ef4e1" # EU (Paris)
    eu-central-1   = "ami-0291ba887ba0d515f" # EU (Frankfurt)
    ap-northeast-1 = "ami-0041c416aa23033a2" # Asia Pacific (Tokyo)
    ap-northeast-2 = "ami-047d2a61f94f862dc" # Asia Pacific (Seoul)
    ap-southeast-1 = "ami-091bf462afdb02c60" # Asia Pacific (Singapore)
    ap-southeast-2 = "ami-0092e55c70015d8c3" # Asia Pacific (Sydney)
    ap-south-1     = "ami-0c179ca015d301829" # Asia Pacific (Mumbai)
    sa-east-1      = "ami-0018ff8ee48970ac3" # South America (São Paulo)
    us-gov-west-1  = "ami-c6079ba7"          # GovCloud
  }
}

variable "project" {
  description = "Project identifier"
  type        = "string"
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
