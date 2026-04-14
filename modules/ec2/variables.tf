variable "name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
}

variable "attach_eip" {
  description = "Whether to attach an Elastic IP to the instance"
  type        = bool
  default     = false
}
