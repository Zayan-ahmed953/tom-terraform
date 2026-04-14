module "vpc" {
  source = "../../modules/vpc"

  name                = "staging"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  public_subnet_az    = "eu-west-2a"
  private_subnet_az   = "eu-west-2b"
}

module "sg" {
  source = "../../modules/sg"

  name        = "dev-server-sg"
  description = "Security group for dev server"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["139.135.36.209/32", "0.0.0.0/0"]
    },
    {
      description = "HTTPS access"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "ec2" {
  source = "../../modules/ec2"

  name                   = "dev-server"
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.public_subnet_id
  vpc_security_group_ids = [module.sg.security_group_id]
  attach_eip             = true
}

data "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = "dev-ai_sourcing-RDS-Secrets"
}

data "aws_secretsmanager_secret_version" "elasticache_credentials" {
  secret_id = "dev-ai_sourcing-ElastiCache-Secrets"
}

locals {
  rds_credentials         = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string)
  elasticache_credentials = jsondecode(data.aws_secretsmanager_secret_version.elasticache_credentials.secret_string)
}

module "rds" {
  source = "../../modules/rds"

  name           = "tom-db"
  db_name        = "tom"
  engine_version = "16"
  instance_class = "db.t4g.micro"

  username = local.rds_credentials["DB_USER"]
  password = local.rds_credentials["DB_PASSWORD"]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.vpc.public_subnet_id, module.vpc.private_subnet_id]

  publicly_accessible = true
  allowed_cidr_blocks = ["0.0.0.0/0"]

  allowed_security_group_ids = [module.sg.security_group_id]
}

module "elasticache" {
  source = "../../modules/elasticache"

  name       = "tom-cache"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.vpc.public_subnet_id, module.vpc.private_subnet_id]

  auth_token          = local.elasticache_credentials["AUTH_TOKEN"]
  allowed_cidr_blocks = ["0.0.0.0/0"]

  allowed_security_group_ids = [module.sg.security_group_id]
}
