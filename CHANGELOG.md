# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## 2.2.0
- Fix: Replaced deprecated `null_data_resource` with dynamic nested blocks

## 2.1.0

- Fix: Fix boolean (#24) by @Laugslander
- Added: session manager support to ecs instance role
- Added: Allow all types of traffic within VPC instead of only TCP
- Added: Add variable `additional_cidr_blocks` to whitelist extra CIDR blocks within VPC

### Changed

## 2.0.0

- Upgrade to terraform 0.12
- Moved from travis-ci to Github Actions

## 1.4.0

- Add policies to allow dynamic scaling
- Changed: (Breaking change) The default ECS image is changed to the latest amazon linux2 ami available at the time the terraform script is running. To ensure the version is fixed, provide the filter variable with to select an ami. See the [readme][readme.md] for more details

## 1.3.0

- Update default base images to 2018.03.e

## 1.2.0

- Add a second, more advanced example.

## 1.1.0

https://github.com/philips-software/terraform-aws-ecs/tags/1.1.0

- Add extra input variable tags, for tagging resources
- Add extra output variables iam_instance_profile_arn and instance_sg_id

## 1.0.0

https://github.com/philips-software/terraform-aws-ecs/tags/1.0.0

- Update naming of the autoscaling group to be consistent with the other naming conventions.
- Slack badge in documentation
- Updated base images to 2017.9.g
- Refactored module to replace duplicated policies by inline policies
- Replace resources to remove deprecated warnins
- Removed unused, uneeded output variables
- Removed unneeded input variables
- Renamed output variables
- Update of ECS optimized AMI's

[unreleased]: https://github.com/philips-software/terraform-aws-ecs/compare/2.1.0...HEAD

[2.1.0] https://github.com/philips-software/terraform-aws-ecscompare/2.0.0...2.1.0
[2.0.0] https://github.com/philips-software/terraform-aws-ecscompare/1.4.0...2.0.0
[1.4.0] https://github.com/philips-software/terraform-aws-ecscompare/1.3.0...1.4.0
[1.3.0] https://github.com/philips-software/terraform-aws-ecscompare/1.2.0...1.3.0
[1.2.0] https://github.com/philips-software/terraform-aws-ecscompare/1.1.0...1.2.0
[1.1.0] https://github.com/philips-software/terraform-aws-ecscompare/1.0.0...1.1.0
