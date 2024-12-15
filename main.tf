module "web_server_with_db" {
  source = "./web-server-module"
}

# Module Definition: `web-server-module`
# main.tf
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "main" {
  count = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
}

resource "aws_security_group" "web" {
  name_prefix = "web-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "web" {
  name          = "web-launch-configuration"
  image_id      = var.web_server_ami
  instance_type = var.web_server_instance_type

  security_groups = [aws_security_group.web.id]

  user_data = <<-EOT
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              echo "Hello, World from Terraform Web Server!" > /var/www/html/index.html
              EOT

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  desired_capacity     = var.web_server_desired_capacity
  max_size             = var.web_server_max_size
  min_size             = var.web_server_min_size
  vpc_zone_identifier  = aws_subnet.main[*].id
  launch_configuration = aws_launch_configuration.web.id

  tag {
    key                 = "Name"
    value               = "web-server"
    propagate_at_launch = true
  }
}

resource "aws_db_instance" "main" {
  allocated_storage    = var.db_allocated_storage
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  publicly_accessible  = false
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.web.id]
}

# variables.tf
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "List of subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "web_server_ami" {
  description = "AMI for the web server"
  type        = string
}

variable "web_server_instance_type" {
  description = "Instance type for the web server"
  type        = string
  default     = "t2.micro"
}

variable "web_server_desired_capacity" {
  description = "Desired number of web servers"
  type        = number
  default     = 2
}

variable "web_server_min_size" {
  description = "Minimum number of web servers"
  type        = number
  default     = 1
}

variable "web_server_max_size" {
  description = "Maximum number of web servers"
  type        = number
  default     = 4
}

variable "db_allocated_storage" {
  description = "Allocated storage for the database in GB"
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "Instance class for the database"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# outputs.tf
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "web_server_dns" {
  description = "DNS of the web servers"
  value       = aws_autoscaling_group.web.load_balancers
}

output "db_endpoint" {
  description = "Database endpoint"
  value       = aws_db_instance.main.endpoint
}
