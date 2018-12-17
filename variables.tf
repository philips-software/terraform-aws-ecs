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
  description = "List with ecs optimized images per region, last updated on: 2018-12-17 (2018.03.i)."
  type        = "map"

  default = {
    us-east-1      = "ami-045f1b3f87ed83659" # US East (N. Virginia)
    us-east-2      = "ami-0307f7ccf6ea35750" # US East (Ohio)
    us-west-1      = "ami-0285183bbef6224bd" # US West (N. California)
    us-west-2      = "ami-01b70aea4161476b7" # US West (Oregon)
    ca-central-1   = "ami-0f552e0a86f08b660" # Canada (Central)
    eu-west-1      = "ami-0627e141ce928067c" # EU (Ireland)
    eu-west-2      = "ami-01bee3897bba49d78" # EU (London)
    eu-west-3      = "ami-0f4738fbeb53e6c3a" # EU (Paris)
    eu-central-1   = "ami-0eaa3baf6969912ba" # EU (Frankfurt)
    ap-northeast-1 = "ami-05b296a384694dfa4" # Asia Pacific (Tokyo)
    ap-northeast-2 = "ami-00294948a592fc052" # Asia Pacific (Seoul)
    ap-southeast-1 = "ami-050865a806e0dae53" # Asia Pacific (Singapore)
    ap-southeast-2 = "ami-02c73ee1100ce3e7a" # Asia Pacific (Sydney)
    ap-south-1     = "ami-01ef9f6a829ae3956" # Asia Pacific (Mumbai)
    sa-east-1      = "ami-084b1eee100c102ee" # South America (São Paulo)
    us-gov-west-1  = "ami-1dafcb7c"          # GovCloud
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
