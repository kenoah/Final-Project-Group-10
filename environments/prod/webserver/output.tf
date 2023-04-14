output "bastion_server_id" {
  value = module.webserver-prod.bastion_server_id
}

output "launch_template_id" {
  value = module.webserver-prod.launch_template_id
}

output "auto_scaling_group_id" {
  value = module.webserver-prod.auto_scaling_group_id
}

output "load_balancer_id" {
  value = module.webserver-prod.load_balancer_id
}

output "target_group_arn" {
  value = module.webserver-prod.target_group_arn
}