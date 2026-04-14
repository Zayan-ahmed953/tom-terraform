variable "vpc_name" {
  type        = string
  description = "Name tag for the VPC."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet."
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet."
}

variable "public_subnet_az" {
  type        = string
  description = "Availability zone for the public subnet."
}

variable "private_subnet_az" {
  type        = string
  description = "Availability zone for the private subnet."
}

variable "sg_name" {
  type        = string
  description = "Name of the security group."
}

variable "sg_description" {
  type        = string
  description = "Description of the security group."
}

variable "sg_ingress_rules" {
  description = "Ingress rules for the security group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "ec2_name" {
  type        = string
  description = "Name tag for the EC2 instance."
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "ec2_attach_eip" {
  type        = bool
  description = "Whether to attach an Elastic IP to EC2."
}

variable "rds_secret_id" {
  type        = string
  description = "Secrets Manager secret ID for RDS credentials."
}

variable "elasticache_secret_id" {
  type        = string
  description = "Secrets Manager secret ID for ElastiCache credentials."
}

variable "rds_name" {
  type        = string
  description = "Identifier name for the RDS instance."
}

variable "rds_db_name" {
  type        = string
  description = "Database name for RDS."
}

variable "rds_engine_version" {
  type        = string
  description = "RDS engine version."
}

variable "rds_instance_class" {
  type        = string
  description = "RDS instance class."
}

variable "rds_publicly_accessible" {
  type        = bool
  description = "Whether RDS is publicly accessible."
}

variable "rds_allowed_cidr_blocks" {
  type        = list(string)
  description = "Allowed CIDR blocks for RDS ingress."
}

variable "elasticache_name" {
  type        = string
  description = "Name for the ElastiCache replication group."
}

variable "elasticache_allowed_cidr_blocks" {
  type        = list(string)
  description = "Allowed CIDR blocks for ElastiCache ingress."
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the uploads S3 bucket."
}
