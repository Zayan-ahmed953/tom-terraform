resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name}-cache-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-cache-subnet-group"
  }
}

resource "aws_security_group" "this" {
  name        = "${var.name}-cache-sg"
  description = "Security group for ${var.name} ElastiCache Redis"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Redis access from allowed SGs"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
  }

  ingress {
    description = "Redis access from anywhere"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-cache-sg"
  }
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = var.name
  description          = "Redis replication group for ${var.name}"
  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_clusters   = 1

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.this.id]

  transit_encryption_enabled = true
  auth_token                 = var.auth_token

  port = 6379

  tags = {
    Name = var.name
  }
}
