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

  key_name = "${aws_key_pair.key.key_name}"

  vpc_id   = "${module.vpc.vpc_id}"
  vpc_cidr = "${module.vpc.vpc_cidr}"

  min_instance_count     = "1"
  max_instance_count     = "1"
  desired_instance_count = "1"

  ecs_ami_filter = ["${var.filter}"]
  instance_type  = "t2.micro"

  subnet_ids = "${join(",", module.vpc.private_subnets)}"

  project = "${var.project}"

  tags = "${var.tags}"
}
