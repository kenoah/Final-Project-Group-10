output "vpc_id" {
  value = module.network-prod.vpc_id
}

output "public_subnet_ids" {
  value = module.network-prod.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network-prod.private_subnet_ids
}