variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project Name used as a prefix for resources"
  type        = string
  default     = "ecs-project"
}