variable "aws_region" {
  type        = "string"
  description = "The Amazon region: currently North Virginia [us-east-1]."
}

variable "environment" {
  description = "Name of the environment (e.g. cheetah-dev); will be prefixed to all resources."
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
  description = "List with ecs optimized images per region, last updated on: 2018-01-19 (2017.09.g)."
  type        = "map"

  default = {
    us-east-1      = "ami-28456852" # N. Virginia
    us-east-2      = "ami-ce1c36ab"
    us-west-1      = "ami-74262414" # N. California
    us-west-2      = "ami-decc7fa6" # Oregon
    eu-west-1      = "ami-1d46df64" # Ireland
    eu-west-2      = "ami-67cbd003"
    eu-west-3      = "ami-9aef59e7" # Paris
    eu-central-1   = "ami-509a053f" # Frankfurt
    ap-northeast-1 = "ami-872c4ae1" # Tokyo
    ap-northeast-2 = "ami-c212b2ac"
    ap-southeast-1 = "ami-910d72ed" # Singapore
    ap-southeast-2 = "ami-58bb443a" # Sydney
    ca-central-1   = "ami-435bde27"
    ap-south-1     = "ami-00491f6f"
    sa-east-1      = "ami-af521fc3"
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
