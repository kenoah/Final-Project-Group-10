#Loadbalancer for the webserver instances
resource "aws_lb" "loadBalancer" {
  name               = "${local.name_prefix}-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webSG.id]
  subnets            = data.terraform_remote_state.network.outputs.public_subnet_ids[*]
  depends_on = [
    aws_autoscaling_group.amazonServerASG
  ]
  
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-LoadBalancer"
    }
  )
}

#TargetGroup to route the requests on the targets
resource "aws_lb_target_group" "targetGroup" {
  name     = "${local.name_prefix}-TargetGroup"
  protocol = var.tg_protocol
  port     = var.tg_port
  vpc_id   = data.terraform_remote_state.network.outputs.vpc_id
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
  
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-TargetGroup"
    }
  )
}

#LoadBalancerListener rule
resource "aws_lb_listener" "loadBalancerListener" {
  load_balancer_arn = aws_lb.loadBalancer.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetGroup.arn
  }
}