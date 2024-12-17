# Reference the remote state for database configuration
data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = var.aws_region
  }
}

# Launch Configuration for Webserver Instances
resource "aws_launch_configuration" "webserver" {
  name_prefix   = "${var.cluster_name}-lc-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = var.user_data

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group for Webserver Cluster
resource "aws_autoscaling_group" "webserver_cluster" {
  count                = var.enable_autoscaling ? 1 : 0
  name                 = var.cluster_name
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.min_size
  launch_configuration = aws_launch_configuration.webserver.name
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}

# Default Fixed Instance (if autoscaling is disabled)
resource "aws_instance" "webserver_instance" {
  count         = var.enable_autoscaling ? 0 : var.min_size
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[0]
  user_data     = var.user_data

  tags = {
    Name = var.cluster_name
  }
}
