module "vpc" {
  source  = "philips-software/vpc/aws"
  version = "1.0.0"

  environment = "${var.environment}"
  aws_region  = "${var.aws_region}"
}

resource "aws_key_pair" "key" {
  key_name   = "${var.key_name}"
  public_key = "${file("${var.ssh_key_file_ecs}")}"
}

data "template_file" "ecs-instance-user-data" {
  template = "${file("${path.module}/user-data-ecs-cluster-instance.tpl")}"

  vars {
    ecs_cluster_name = "${module.ecs-cluster.name}"
  }
}

module "ecs-cluster" {
  source    = "../../"
  user_data = "${data.template_file.ecs-instance-user-data.rendered}"

  aws_region  = "${var.aws_region}"
  environment = "${var.environment}"

  key_name = "${var.key_name}"

  vpc_id   = "${module.vpc.vpc_id}"
  vpc_cidr = "${module.vpc.vpc_cidr}"

  min_instance_count     = "1"
  max_instance_count     = "1"
  desired_instance_count = "1"

  instance_type = "t2.micro"

  subnet_ids = "${join(",", module.vpc.private_subnets)}"

  project = "${var.project}"
}

module "blog" {
  source = "ecs-service"

  // This is included in this test directory. You can also use: https://github.com/philips-software/terraform-aws-ecs-service

  aws_region            = "${var.aws_region}"
  environment           = "${var.environment}"
  vpc_id                = "${module.vpc.vpc_id}"
  public_subnets        = "${join(",", module.vpc.public_subnets)}"
  cluster_id            = "${module.ecs-cluster.id}"
  ecs_service_role_name = "${module.ecs-cluster.service_role_name}"
  service_name          = "blog"
}
