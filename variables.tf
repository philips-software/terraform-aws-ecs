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
  description = "List with ecs optimized images per region, last updated on: 2018-06-20 (2018.03.a)."
  type        = "map"

  default = {
    us-east-1      = "ami-5253c32d" # N. Virginia
    us-east-2      = "ami-956e52f0"
    us-west-1      = "ami-6b81980b" # N. California
    us-west-2      = "ami-d2f489aa" # Oregon
    eu-west-1      = "ami-c91624b0" # Ireland
    eu-west-2      = "ami-3622cf51"
    eu-west-3      = "ami-ca75c4b7" # Paris
    eu-central-1   = "ami-10e6c8fb" # Frankfurt
    ap-northeast-1 = "ami-f3f8098c" # Tokyo
    ap-northeast-2 = "ami-7c69c112"
    ap-southeast-1 = "ami-b75a6acb" # Singapore
    ap-southeast-2 = "ami-bc04d5de" # Sydney
    ca-central-1   = "ami-da6cecbe"
    ap-south-1     = "ami-c7072aa8"
    sa-east-1      = "ami-a1e2becd"
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
