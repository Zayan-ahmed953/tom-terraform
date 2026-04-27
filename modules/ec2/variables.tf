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

variable "ami" {
  description = "AMI ID to use for the instance. If not set, the latest Ubuntu 24.04 AMI is used."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 8
}

variable "source_dest_check" {
  description = "Whether to enable source/destination check on the instance"
  type        = bool
  default     = true
}