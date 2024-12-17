output "webserver_asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.webserver_cluster[0].name
}

output "webserver_instance_ips" {
  description = "The private IP addresses of the webserver instances"
  value       = aws_instance.webserver_instance[*].private_ip
}

output "db_connection_string" {
  description = "The database connection string from remote state"
  value       = data.terraform_remote_state.db.outputs.db_connection_string
}
