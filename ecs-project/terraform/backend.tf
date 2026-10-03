terraform {
  backend "s3" {
    bucket       = "ecs-project-tfstate-777285773915"
    key          = "ecs-project/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true
  }
}