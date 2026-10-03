module "vpc" {
  source   = "./modules/vpc"
  name     = var.project_name
  vpc_cidr = "10.0.0.0/16"
}

module "ecr" {
  source = "./modules/ecr"
  name   = var.project_name
}

module "security_groups" {
  source = "./modules/security-groups"
  name   = var.project_name
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"
  name   = var.project_name
}

module "acm" {
  source      = "./modules/acm"
  domain_name = "tm.ismaaeelahmed.co.uk"
}

module "alb" {
  source            = "./modules/alb"
  name              = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  certificate_arn   = module.acm.certificate_arn
}

module "ecs" {
  source             = "./modules/ecs"
  name               = var.project_name
  aws_region         = var.aws_region
  public_subnet_ids  = module.vpc.public_subnet_ids
  service_sg_id      = module.security_groups.service_sg_id
  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn
  ecr_repository_url = module.ecr.repository_url
  target_group_arn   = module.alb.target_group_arn
}

module "oidc" {
  source      = "./modules/oidc"
  name        = var.project_name
  github_repo = "ismaaeelahmed11/devops-learning"
}