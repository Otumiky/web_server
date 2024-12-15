resource "aws_security_group" "webserver" {
  name        = "${var.cluster_name}-web-sg"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "webserver" {
  name          = "${var.cluster_name}-lc"
  image_id      = var.ami
  instance_type = var.instance_type
  security_groups = [
    aws_security_group.webserver.id,
  ]
  user_data = <<-EOF
              #!/bin/bash
              echo "${var.server_text}" > /var/www/html/index.html
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
  EOF
}

resource "aws_autoscaling_group" "webserver" {
  name                 = "${var.cluster_name}-asg"
  launch_configuration = aws_launch_configuration.webserver.id
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = var.subnet_ids

  lifecycle {
    create_before_destroy = true
  }
}

output "webserver_autoscaling_group_name" {
  value = aws_autoscaling_group.webserver.name
}
