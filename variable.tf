variable "server_port" {
    description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}


variable "instance_type" {
  description = "The type of EC2 instances "
  type = string
}

variable "asg_name" {
  description = "The name use for the aws_security_group"
  type = string
}
