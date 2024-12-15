output "security_group_id" {
  value       = aws_security_group.webserver.id
  description = "ID of the security group for the webserver"
}

output "autoscaling_group_name" {
  value       = aws_autoscaling_group.webserver.name
  description = "Name of the autoscaling group"
}
