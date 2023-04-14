output "bastion_server_id" {
  value = module.webserver-staging.bastion_server_id
}

output "launch_template_id" {
  value = module.webserver-staging.launch_template_id
}

output "auto_scaling_group_id" {
  value = module.webserver-staging.auto_scaling_group_id
}

output "load_balancer_id" {
  value = module.webserver-staging.load_balancer_id
}

output "target_group_arn" {
  value = module.webserver-staging.target_group_arn
}