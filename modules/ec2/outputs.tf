output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP of the instance (EIP if attached, otherwise instance public IP)"
  value       = var.attach_eip ? aws_eip.this[0].public_ip : aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.this.private_ip
}
