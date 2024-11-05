resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.product_name}-${var.env_name}-ecs"
}

data "aws_ssm_parameter" "ecs_ami" {
name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}


resource "aws_launch_template" "ecs_launch_template" {
  name          = "${var.product_name}-${var.env_name}-ec2"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
  vpc_security_group_ids = var.security_groups
  tag_specifications {
    resource_type = "instance"
	tags = {
	  Name = "${var.product_name}-${var.env_name}-ec2"
    }
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = [var.subnet_id]
  launch_template {
    id = aws_launch_template.ecs_launch_template.id
	version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.product_name}-${var.env_name}-ec2"
    propagate_at_launch = true
  }
}