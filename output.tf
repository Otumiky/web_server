output "asg_name" {
  description = "The name of the Autoscaling Group"
  value       = aws_autoscaling_group.webserver.name
}

output "security_group_id" {
  description = "The security group ID for the webserver"
  value       = aws_security_group.webserver.id
}
