module "vpc" {
  source = "../../modules/vpc"

  name                = var.vpc_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_az    = var.public_subnet_az
  private_subnet_az   = var.private_subnet_az
}

module "sg" {
  source = "../../modules/sg"

  name        = var.sg_name
  description = var.sg_description
  vpc_id      = module.vpc.vpc_id

  ingress_rules = var.sg_ingress_rules
}

module "ec2" {
  source = "../../modules/ec2"

  name                   = var.ec2_name
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  root_volume_size       = var.ec2_root_volume_size
  subnet_id              = module.vpc.public_subnet_id
  vpc_security_group_ids = [module.sg.security_group_id]
  attach_eip             = var.ec2_attach_eip
  source_dest_check      = false
}

data "aws_security_group" "staging_sg" {
  filter {
    name   = "group-name"
    values = ["staging-sg"]
  }

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

data "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = var.rds_secret_id
}

data "aws_secretsmanager_secret_version" "elasticache_credentials" {
  secret_id = var.elasticache_secret_id
}

locals {
  rds_credentials         = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string)
  elasticache_credentials = jsondecode(data.aws_secretsmanager_secret_version.elasticache_credentials.secret_string)
}

module "rds" {
  source = "../../modules/rds"

  name           = var.rds_name
  db_name        = var.rds_db_name
  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class

  username = local.rds_credentials["DB_USER"]
  password = local.rds_credentials["DB_PASSWORD"]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.vpc.public_subnet_id, module.vpc.private_subnet_id]

  publicly_accessible = var.rds_publicly_accessible
  allowed_cidr_blocks = var.rds_allowed_cidr_blocks

  allowed_security_group_ids = [module.sg.security_group_id, data.aws_security_group.staging_sg.id]
}

module "elasticache" {
  source = "../../modules/elasticache"

  name       = var.elasticache_name
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.vpc.public_subnet_id, module.vpc.private_subnet_id]

  auth_token          = local.elasticache_credentials["AUTH_TOKEN"]
  allowed_cidr_blocks = var.elasticache_allowed_cidr_blocks

  allowed_security_group_ids = [module.sg.security_group_id]
}

module "iam_s3_user" {
  source = "../../modules/iam"

  name           = var.iam_s3_user_name
  s3_bucket_name = var.s3_bucket_name
}

module "s3" {
  source = "../../modules/s3"

  bucket_name  = var.s3_bucket_name
  iam_user_arn = module.iam_s3_user.iam_user_arn
}
