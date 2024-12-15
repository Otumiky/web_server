resource "aws_security_group" "webserver" {
  name        = "${var.cluster_name}-sg"
  description = "Allow HTTP and SSH traffic for webserver"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
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

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = var.aws_region
  }
}

resource "aws_launch_template" "webserver" {
  name_prefix   = "${var.cluster_name}-lt"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    server_text = var.server_text
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  }))

  network_interfaces {
    security_groups = [aws_security_group.webserver.id]
  }
}

resource "aws_autoscaling_group" "webserver" {
  desired_capacity     = var.min_size
  max_size             = var.max_size
  min_size             = var.min_size
  launch_template      = { id = aws_launch_template.webserver.id }
  vpc_zone_identifier  = var.subnet_ids
  health_check_type    = "EC2"
  health_check_grace_period = 300
  tags = [
    {
      key                 = "Name"
      value               = var.cluster_name
      propagate_at_launch = true
    }
  ]
}

output "webserver_sg_id" {
  value = aws_security_group.webserver.id
}
