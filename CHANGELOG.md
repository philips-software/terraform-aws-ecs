# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
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

[Unreleased]: https://github.com/philips-software/terraform-aws-ecs/compare/1.1.0...HEAD
[1.1.0] https://github.com/philips-software/terraform-aws-ecscompare/1.0.0...1.1.0
