variable "ami" {
  description = "AMI ID for the webserver"
  type        = string
}

variable "server_text" {
  description = "Text to display on the webserver homepage"
  type        = string
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "db_remote_state_bucket" {
  description = "S3 bucket for the database remote state"
  type        = string
}

variable "db_remote_state_key" {
  description = "Key for the database remote state in the S3 bucket"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the webserver"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the autoscaling group"
  type        = list(string)
}

variable "server_port" {
  description = "Port for the webserver"
  type        = number
  default     = 80
}

variable "min_size" {
  description = "Minimum number of instances in the autoscaling group"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in the autoscaling group"
  type        = number
}

variable "aws_region" {
  description = "AWS region for the resources"
  type        = string
  default     = "us-east-1"
}
