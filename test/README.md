# Test ECS

This directory contains a test setup for an ECS cluster. Once applied one services will be available via HTTP. Se console output after apply for the url.

Execute the steps below to setup the cluster.

## Start terraform docker container to execute terraform scripts
```
docker run --env-file $HOME/.aws/<AWS_KEYS> \
             -v $(pwd):/data --workdir=/data --entrypoint=/bin/bash -it --rm digilabs/terraform:0.9.9
```
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
