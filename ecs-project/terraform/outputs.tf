output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "alb_sg_id" {
  value = module.security_groups.alb_sg_id
}

output "service_sg_id" {
  value = module.security_groups.service_sg_id
}

output "execution_role_arn" {
  value = module.iam.execution_role_arn
}

output "task_role_arn" {
  value = module.iam.task_role_arn
}

output "certificate_arn" {
  value = module.acm.certificate_arn
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "github_actions_role_arn" {
  value = module.oidc.github_actions_role_arn
}