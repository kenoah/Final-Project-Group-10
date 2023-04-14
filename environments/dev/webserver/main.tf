module "webserver-dev" {
  source               = "../../../modules/aws_webserver"
  env                  = var.env
  instance_type        = var.instance_type
  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity
  default_tags         = var.default_tags
}