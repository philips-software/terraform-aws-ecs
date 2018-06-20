# Test ECS

This directory contains a test setup for an ECS cluster. Once applied one services will be available via HTTP. Se console output after apply for the url.

Execute the steps below to setup the cluster.

## Prerequisites for running the example
Terraform is managed via the tool `tfenv`. Ensure you have installed [tfenv](https://github.com/kamatama41/tfenv). And install via tfenv the required terraform version as listed in `.terraform-version`

## Generate ssh and init terraform

```
source ./generate-ssh-key.sh
terraform init

```

## Plan the changes and inspect

```
terraform plan
```

## Create the environment.

```
terraform apply
```

Once done you can test the service via the URL on the console. It can take a few minutes before the service is available


## Cleanup

```
terraform destroy
```
