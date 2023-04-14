output "vpc_id" {
  value = module.network-dev.vpc_id
}

output "public_subnet_ids" {
  value = module.network-dev.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network-dev.private_subnet_ids
}