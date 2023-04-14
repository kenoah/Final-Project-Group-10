output "bastion_server_id" {
  value = aws_instance.bastionServer.id
}

output "launch_template_id" {
  value = aws_launch_template.amazonWebserver.id
}

output "auto_scaling_group_id" {
  value = aws_autoscaling_group.amazonServerASG.id
}

output "load_balancer_id" {
  value = aws_lb.loadBalancer.id
}

output "target_group_arn" {
  value = aws_lb_target_group.targetGroup.arn
}