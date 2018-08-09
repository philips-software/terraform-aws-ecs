# ECS example

This example shows the usages of the ECS cluster. The example will deploy one container running web application in the cluster. The example shows the following features:
- ECS cluster module usages
- Running one simple service
- AWS verified [VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.37.0)
- Service based on [Philips ECS service module](https://github.com/philips-software/terraform-aws-ecs-service) including centralized logging and basic monitoring.

## Prerequisites for running the example
Terraform is managed via the tool `tfenv`. Ensure you have installed [tfenv](https://github.com/kamatama41/tfenv). And install via tfenv the required terraform version as listed in `.terraform-version`

## Run the example

Just run the default terraform commands.


### Setup

```
terraform init
```

### Plan the changes and inspect

```
terraform plan
```

### Create the environment.

```
terraform apply
```

Once done you can test the service via the URL on the console. It can take a few minutes before the service is available


### Cleanup

```
terraform destroy
```

### Structure of example
- `main.tf` : ECS cluster
- `vpc.tf` : VPC network layer
- `service.tf` : ECS service (container)
- `keys.tf` : SSH key creation
- `providers.tf` : Required providers
- `monitoring.tf` : Log group, topics
