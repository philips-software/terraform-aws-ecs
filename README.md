# Terraform module for creating a ecs cluster

![badge](https://action-badges.now.sh/philips-software/terraform-aws-ecs)

This [Terraform module]() creates a ECS container cluster in Amazon. Prerequisite is to have a a VPC available. The VPC can be create via the official verified [AWS VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.37.0), or via the our own [VPC](https://github.com/philips-software/terraform-aws-vpc) module.

The module creates a ECS cluster by default using one EC2 instance. No auto scaling is configured, currently scaling can only be done by change parameters, see examples below.

_Note:_ Release 1.4.0 contains the following backwards incompatible changes

- Default ECS AMI is from now on the latest Amazon linux available at the time terraform is executed. The AMI version can be fixed by setting the filter variable: `ecs_ami_filter`, see the example below. Functional the change can be implemented backwards compatible by setting the filter to the image that you was using before the upgrade.

## Terraform version

- Terraform 0.12: Pin module to `~> 2+`, submit pull request to branch `develop`
- Terraform 0.11: Pin module to `~> 1.x`, submit pull request to branch `terrafomr012`

## Examples

- [ECS cluster basic](examples/ecs-cluster-advanced) - This examples combines the usage of the VPC module, ECS cluster (this module), ECS service module, centralized logging.
- [ECS cluster advanced](examples/ecs-cluster-advanced) - A slightly more advanced example. This examples combines the usage of the AWS VPC module, ECS cluster (this module), ECS service module, centralized logging and monitoring.

## Usage

Below an example usages. Complete examples are provided in the `examples` directory.

```
module "ecs-cluster" {
  source = "git::https://github.com/philips-software/terraform-aws-ecs-cluster.git?ref=terraform012"

  user_data = data.template_file.ecs-instance-user-data.rendered

  aws_region  = var.aws_region
  environment = var.environment

  key_name = aws_key_pair.key.key_name

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr

  min_instance_count     = 1
  max_instance_count     = 1
  desired_instance_count = 1

  #ecs_ami_filter = ["${var.filter}"]
  instance_type = "t2.micro"

  subnet_ids = join(",", module.vpc.private_subnets)

  project = var.project

  tags = var.tags
}


data "template_file" "ecs-instance-template" {
    template = file("<my template file>")

    vars = {
        /* my template variables */
    }
}
```

## Inputs

| Name                       | Description                                                                                                                                         | Type                | Default                                                                                                     | Required |
|----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|-------------------------------------------------------------------------------------------------------------|:--------:|
| additional_cidr_blocks     | Additional CIDR blocks that will be whitelisted within the VPC next to the VPC's CIDR block. Default is an empty list.                              | `list`              | `[]`                                                                                                        |    no    |
| additional_ingress         | Additional VPC ingress.                                                                                                                             | `list(object)`      | `[]`                                                                                                        |    no    |
| aws_region                 | The Amazon region: currently North Virginia [us-east-1].                                                                                            | `string`            | n/a                                                                                                         |   yes    |
| desired_instance_count     | The desired instance count in the cluster.                                                                                                          | `number`            | `1`                                                                                                         |    no    |
| dynamic_scaling            | Enable/disable dynamic scaling of the auto scaling group.                                                                                           | `bool`              | `false`                                                                                                     |    no    |
| dynamic_scaling_adjustment | The adjustment in number of instances for dynamic scaling.                                                                                          | `number`            | `1`                                                                                                         |    no    |
| ecs_ami_filter             | The filter used to select the AMI for the ECS cluster. By default the the pattern `amzn2-ami-ecs-hvm-2.0.????????-x86_64-ebs` for the name is used. | `list(map(string))` | <pre>[<br> {<br> "name": "name",<br> "values": "amzn2-ami-ecs-hvm-2.0.????????-x86_64-ebs"<br> }<br>]</pre> |    no    |
| ecs_ami_latest             | Indicator to use the latest avaiable in the the list of the AMI's for the ECS cluster.                                                              | `bool`              | `true`                                                                                                      |    no    |
| ecs_ami_include_deprecated | If true, all deprecated AMIs are included in the response. If false, no deprecated AMIs are included in the response.                               | `bool`              | `false`                                                                                                     |    no    |
| ecs_ami_owners             | A list of owners used to select the AMI for the ECS cluster.                                                                                        | `list(string)`      | <pre>[<br> "amazon"<br>]</pre>                                                                              |    no    |
| ecs_optimized_type         | Possible values                                                                                                                                     | `string`            | `"amzn2"`                                                                                                   |    no    |
| environment                | Name of the environment; will be prefixed to all resources.                                                                                         | `string`            | n/a                                                                                                         |   yes    |
| instance_type              | The instance type used in the cluster.                                                                                                              | `string`            | n/a                                                                                                         |   yes    |
| key_name                   | The AWS keyname, used to create instances.                                                                                                          | `string`            | n/a                                                                                                         |   yes    |
| max_instance_count         | The maximum instance count in the cluster.                                                                                                          | `number`            | `1`                                                                                                         |    no    |
| min_instance_count         | The minimal instance count in the cluster.                                                                                                          | `number`            | `1`                                                                                                         |    no    |
| project                    | Project identifier                                                                                                                                  | `string`            | n/a                                                                                                         |   yes    |
| subnet_ids                 | List of subnets ids on which the instances will be launched.                                                                                        | `string`            | n/a                                                                                                         |   yes    |
| tags                       | Map of tags to apply on the resources                                                                                                               | `map(string)`       | `{}`                                                                                                        |    no    |
| user_data                  | The user-data for the ec2 instances                                                                                                                 | `string`            | n/a                                                                                                         |   yes    |
| vpc_cidr                   | The CIDR block of the VPC (e.g. 10.64.48.0/23).                                                                                                     | `string`            | n/a                                                                                                         |   yes    |
| vpc_id                     | The VPC to launch the instance in (e.g. vpc-66ecaa02).                                                                                              | `string`            | n/a                                                                                                         |   yes    |

## Outputs

| Name                            | Description                                     |
| ------------------------------- | ----------------------------------------------- |
| autoscaling_group_name          | Created auto scaling group for cluster.         |
| autoscaling_policy_scaleIn_arn  | Created auto scaling group policy for scaleIn.  |
| autoscaling_policy_scaleOut_arn | Created auto scaling group policy for scaleOut. |
| iam_instance_profile_arn        | Created IAM instance profile.                   |
| id                              | Id of the cluster.                              |
| instance_sg_id                  | Created security group for cluster instances.   |
| name                            | Name of the cluster.                            |
| service_role_name               | Created IAM service role name.                  |

## Automated checks

Currently the automated checks are limited. In CI the following checks are done for the root and each example.

- lint: `terraform validate` and `terraform fmt`
- basic init / get check: `terraform init -get -backend=false -input=false`

## Automated checks

Currently the automated checks are limited. In CI the following checks are done for the root and each example.

- lint: `terraform validate` and `terraform fmt`
- basic init / get check: `terraform init -get -backend=false -input=false`

## Generation variable documentation

A markdown table for variables can be generated as follow. Generation requires awk and terraform-docs installed.

```
 .ci/bin/terraform-docs.sh markdown
```

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
