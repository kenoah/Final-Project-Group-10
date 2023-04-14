output "bastion_server_id" {
  value = module.webserver-dev.bastion_server_id
}

output "launch_template_id" {
  value = module.webserver-dev.launch_template_id
}

output "auto_scaling_group_id" {
  value = module.webserver-dev.auto_scaling_group_id
}

output "load_balancer_id" {
  value = module.webserver-dev.load_balancer_id
}

output "target_group_arn" {
  value = module.webserver-dev.target_group_arn
}