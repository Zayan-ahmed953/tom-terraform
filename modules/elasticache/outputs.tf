output "endpoint" {
  description = "Primary endpoint address for the Redis replication group"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "port" {
  description = "Port for the Redis instance"
  value       = aws_elasticache_replication_group.this.port
}

output "security_group_id" {
  description = "ID of the ElastiCache security group"
  value       = aws_security_group.this.id
}
