variable "cluster_name" {
  description = "Name of the webserver cluster"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to deploy the cluster into"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the autoscaling group"
  type        = list(string)
}

variable "ami" {
  description = "AMI ID to use for the webserver instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the webserver"
  type        = string
  default     = "t2.micro"
}

variable "server_port" {
  description = "The port on which the webserver will listen"
  type        = number
  default     = 80
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the webserver"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "min_size" {
  description = "Minimum size of the autoscaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the autoscaling group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances in the autoscaling group"
  type        = number
  default     = 1
}

variable "server_text" {
  description = "Custom text to display on the webserver homepage"
  type        = string
  default     = "Hello from Terraform!"
}
