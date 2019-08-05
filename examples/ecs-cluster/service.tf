module "blog" {
  source = "./ecs-service"

  aws_region            = var.aws_region
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnets        = join(",", module.vpc.public_subnets)
  cluster_id            = module.ecs-cluster.id
  ecs_service_role_name = module.ecs-cluster.service_role_name
  service_name          = "blog"
}

