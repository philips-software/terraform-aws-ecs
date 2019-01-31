# Terraform module for creating a ecs cluster
[![Build Status](https://travis-ci.com/philips-software/terraform-aws-ecs.svg?branch=develop)](https://travis-ci.com/philips-software/terraform-aws-ecs)

This [Terraform module]() creates a ECS container cluster in Amazon. Prerequisite is to have a a VPC available. The VPC can be create via the official verified [AWS VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.37.0), or via the our own [VPC](https://github.com/philips-software/terraform-aws-vpc) module.

The module creates a ECS cluster by default using one EC2 instance. No auto scaling is configured, currently scaling can only be done by change parameters, see examples below.

*Note:* Release 2.x contains the following backwards incompatible changes
- Default ECS AMI is from now on the latest Amazon linux available at the time terraform is executed. The AMI version can be fixed by setting the filter variable: `ecs_ami_filter`, see the example below. Functional the change can be implemented backwards compatible by setting the filter to the image that you was using before the upgrade.

## Examples
- [ECS cluster basic](examples/ecs-cluster-advanced) - This examples combines the usage of the VPC module, ECS cluster (this module), ECS service module, centralized logging.
- [ECS cluster advanced](examples/ecs-cluster-advanced) - A slightly more advanced example. This examples combines the usage of the AWS VPC module, ECS cluster (this module), ECS service module, centralized logging and monitoring.

## Usage
Below an example usages. Complete examples are provided in the `examples` directory.

```
module "ecs-cluster" {
    source = "philips-software/ecs/aws"
    version = "1.0.0"

    # Or via github
    # source = "github.com/philips-software/terraform-aws-ecs?ref=1.0.0"

    aws_region  = "eu-west-1"
    environment = "my-environment-name"
    project     = "my project"

    key_name = "my-key"

    // see vpc module for an example
    vpc_id   = "${module.vpc.vpc_id}"
    vpc_cidr = "${module.vpc.vpc_cidr}"

    instance_type = "t2.medium"

    subnet_ids = "${module.vpc.private_subnet_a_id},${module.vpc.private_subnet_b_id}"

    user_data = "${data.template_file.ecs-instance-template.rendered}"

    // optional variables
    min_instance_count     = "1"
    max_instance_count     = "5"
    desired_instance_count = "1"

    tags = {
      my-tag = "my-tag-value"
    }

    # Select the AMI for ECS instances
    ecs_ami_filter = [{
      name   = "name"
      values = ["amzn-ami-2018.09.i-amazon-ecs-optimized"]
    }]

}

data "template_file" "ecs-instance-template" {
    template = "${file("<my template file>")}"

    vars = {
        /* my template variables */
    }
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_region | The Amazon region: currently North Virginia [us-east-1]. | string | - | yes |
| desired_instance_count | The desired instance count in the cluster. | string | `1` | no |
| ecs_ami_filter | The filter used to select the AMI for the ECS cluster. By default the the pattern `amzn2-ami-ecs-hvm-2.0.????????-x86_64-ebs` for the name is used. | list | `<list>` | no |
| ecs_ami_latest | Indicator to use the latest avaiable in the the list of the AMI's for the ECS cluster. | string | `true` | no |
| ecs_ami_owners | A list of owners used to select the AMI for the ECS cluster. | list | `<list>` | no |
| ecs_optimized_type | Possible values | string | `amzn2` | no |
| environment | Name of the environment; will be prefixed to all resources. | string | - | yes |
| instance_type | The instance type used in the cluster. | string | - | yes |
| key_name | The AWS keyname, used to create instances. | string | - | yes |
| max_instance_count | The maximum instance count in the cluster. | string | `1` | no |
| min_instance_count | The minimal instance count in the cluster. | string | `1` | no |
| project | Project identifier | string | - | yes |
| dynamic_scaling | Enable/disable dynamic scaling of the auto scaling group. | string | '1' | no |
| dynamic_scaling_adjustment | The adjustment in number of instances for dynamic scaling. | string | 'false' | no |
| subnet_ids | List of subnets ids on which the instances will be launched. | string | - | yes |
| tags | Map of tags to apply on the resources | map | `<map>` | no |
| user_data | The user-data for the ec2 instances | string | - | yes |
| vpc_cidr | The CIDR block of the VPC (e.g. 10.64.48.0/23). | string | - | yes |
| vpc_id | The VPC to launch the instance in (e.g. vpc-66ecaa02). | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| iam_instance_profile_arn | Created IAM instance profile. |
| id | Id of the cluster. |
| instance_sg_id | Created security group for cluster instances. |
| name | Name of the cluster. |
| service_role_name | Created IAM service role name. |
| autoscaling_group_name | Created auto scaling group for cluster. |
| autoscaling_policy_scaleIn_arn | Created auto scaling group policy for scaleIn. |
| autoscaling_policy_scaleOut_arn | Created auto scaling group policy for scaleOut. |


## Automated checks
Currently the automated checks are limited. In CI the following checks are done for the root and each example.
- lint: `terraform validate` and `terraform fmt`
- basic init / get check: `terraform init -get -backend=false -input=false`

## Philips Forest

This module is part of the Philips Forest.

```
                                                     ___                   _
                                                    / __\__  _ __ ___  ___| |_
                                                   / _\/ _ \| '__/ _ \/ __| __|
                                                  / / | (_) | | |  __/\__ \ |_
                                                  \/   \___/|_|  \___||___/\__|  

                                                                 Infrastructure
```

Talk to the forestkeepers in the `forest`-channel on Slack.

[![Slack](https://philips-software-slackin.now.sh/badge.svg)](https://philips-software-slackin.now.sh)
