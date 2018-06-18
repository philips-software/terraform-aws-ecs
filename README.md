# Terraform module for creating a ecs cluster

This module creates one ecs cluster in a private vpc zone.
This module requires user-data as input.

*Note:* this modules requires terraform 0.8 or higher.

*Note:* This version duplicates the policy documents for the roles since the solution in version 1.11.2-5 and -6 seems not working.

## Usage
Example usages:
```
module "ecs-cluster" {
    source = "github.com/philips-software/terraform-aws-ecs"
    version = "1.0.0"

    aws_region = "eu-west-1"
    environment = "my-environment-name"
    project = "my project"

    key_name = "my-key"

    // see vpc module for an example
    vpc_id = "${module.vpc.vpc_id}"
    vpc_cidr = "${module.vpc.vpc_cidr}"

    instance_type = "t2.medium"

    subnet_ids = "${module.vpc.private_subnet_a_id},${module.vpc.private_subnet_b_id}"

     user_data = "${data.template_file.ecs-instance-template.rendered}"

    // optional variables
    min_instance_count = "1"
    max_instance_count = "5"
    desired_instance_count = "1"

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
| ecs_optimized_amis | List with ecs optimized images per region, last updated on: 2018-01-19 (2017.09.g). | map | `<map>` | no |
| environment | Name of the environment (e.g. cheetah-dev); will be prefixed to all resources. | string | - | yes |
| instance_type | The instance type used in the cluster. | string | - | yes |
| key_name | The AWS keyname, used to create instances. | string | - | yes |
| max_instance_count | The maximum instance count in the cluster. | string | `1` | no |
| min_instance_count | The minimal instance count in the cluster. | string | `1` | no |
| project | Project identifier | string | - | yes |
| subnet_ids | List of subnets ids on which the instances will be launched. | string | - | yes |
| user_data | The user-data for the ec2 instances | string | - | yes |
| vpc_cidr | The CIDR block of the VPC (e.g. 10.64.48.0/23). | string | - | yes |
| vpc_id | The VPC to launch the instance in (e.g. vpc-66ecaa02). | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | Id of the cluster. |
| name | Name of the cluster. |
| service_role_name | Created IAM service role name. |

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