variable "instance_ami" {
  description = "Amazon Linux 2023 AMI"
  type        = string
  default     = "ami-0729131ef01366759"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}