# Terraform module for creating a ecs cluster
[![Build Status](https://travis-ci.com/philips-software/terraform-aws-ecs.svg?branch=develop)](https://travis-ci.com/philips-software/terraform-aws-ecs)

This [Terraform module]() creates a ECS container cluster in Amazon. Prerequisite is to have a a VPC available. The VPC can be create via the official verified [AWS VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.37.0), or via the our own [VPC](https://github.com/philips-software/terraform-aws-vpc) module.

The module creates a ECS cluster by default using one EC2 instance. No auto scaling is configured, currently scaling can only be done by change parameters, see examples below.

*Note:* Release 1.4.0 contains the following backwards incompatible changes
- Default ECS AMI is from now on the latest Amazon linux available at the time terraform is executed. The AMI version can be fixed by setting the filter variable: `ecs_ami_filter`, see the example below. Functional the change can be implemented backwards compatible by setting the filter to the image that you was using before the upgrade.


## Terraform version

- Terraform 0.12: Pin module to `~> 2+`, submit pull request to branch `terrafomr012`
- Terraform 0.11: Pin module to `~> 1.x`, submit pull request to branch `develop`

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

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_region | The Amazon region: currently North Virginia [us-east-1]. | string | n/a | yes |
| desired\_instance\_count | The desired instance count in the cluster. | number | `"1"` | no |
| dynamic\_scaling | Enable/disable dynamic scaling of the auto scaling group. | bool | `"false"` | no |
| dynamic\_scaling\_adjustment | The adjustment in number of instances for dynamic scaling. | number | `"1"` | no |
| ecs\_ami\_filter | The filter used to select the AMI for the ECS cluster. By default the the pattern `amzn2-ami-ecs-hvm-2.0.????????-x86_64-ebs` for the name is used. | list(map(string)) | `<list>` | no |
| ecs\_ami\_latest | Indicator to use the latest avaiable in the the list of the AMI's for the ECS cluster. | bool | `"true"` | no |
| ecs\_ami\_owners | A list of owners used to select the AMI for the ECS cluster. | list(string) | `<list>` | no |
| ecs\_optimized\_type | Possible values | string | `"amzn2"` | no |
| environment | Name of the environment; will be prefixed to all resources. | string | n/a | yes |
| instance\_type | The instance type used in the cluster. | string | n/a | yes |
| key\_name | The AWS keyname, used to create instances. | string | n/a | yes |
| max\_instance\_count | The maximum instance count in the cluster. | number | `"1"` | no |
| min\_instance\_count | The minimal instance count in the cluster. | number | `"1"` | no |
| project | Project identifier | string | n/a | yes |
| subnet\_ids | List of subnets ids on which the instances will be launched. | string | n/a | yes |
| tags | Map of tags to apply on the resources | map(string) | `<map>` | no |
| user\_data | The user-data for the ec2 instances | string | n/a | yes |
| vpc\_cidr | The CIDR block of the VPC (e.g. 10.64.48.0/23). | string | n/a | yes |
| vpc\_id | The VPC to launch the instance in (e.g. vpc-66ecaa02). | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling\_group\_name | Created auto scaling group for cluster. |
| autoscaling\_policy\_scaleIn\_arn | Created auto scaling group policy for scaleIn. |
| autoscaling\_policy\_scaleOut\_arn | Created auto scaling group policy for scaleOut. |
| iam\_instance\_profile\_arn | Created IAM instance profile. |
| id | Id of the cluster. |
| instance\_sg\_id | Created security group for cluster instances. |
| name | Name of the cluster. |
| service\_role\_name | Created IAM service role name. |


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
