variable "ami" {
  description = "Ubuntu 26.04 AMI"
  type        = string
  default     = "ami-0224ce6f9504665ee"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}