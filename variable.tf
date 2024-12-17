variable "cluster_name" {
  description = "The name of the web server cluster"
  type        = string
}

variable "db_remote_state_bucket" {
  description = "The S3 bucket where the remote state is stored"
  type        = string
}

variable "db_remote_state_key" {
  description = "The key of the remote state file in the S3 bucket"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The type of EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "The minimum number of instances"
  type        = number
}

variable "max_size" {
  description = "The maximum number of instances"
  type        = number
}

variable "enable_autoscaling" {
  description = "Flag to enable or disable autoscaling"
  type        = bool
  default     = false
}

variable "ami_id" {
  description = "The AMI ID for the webserver instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" # Default Amazon Linux AMI
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the instances will be deployed"
  type        = list(string)
}

variable "user_data" {
  description = "The user data script to run on instance launch"
  type        = string
  default     = <<-EOT
              #!/bin/bash
              echo "Hello, World!" > /var/www/html/index.html
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOT
}
