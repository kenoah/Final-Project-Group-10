output "vpc_id" {
  value = module.network-staging.vpc_id
}

output "public_subnet_ids" {
  value = module.network-staging.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network-staging.private_subnet_ids
}