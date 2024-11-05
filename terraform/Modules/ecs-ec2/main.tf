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

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.product_name}-${var.env_name}-ecs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"       
  memory                   = "512" 
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = aws_ecs_cluster.ecs_cluster.name
      image     = "954893909646.dkr.ecr.us-west-2.amazonaws.com/teamcity-dev-ecr:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.product_name}-${var.env_name}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [var.subnet_id]
    security_groups = var.security_groups
    assign_public_ip = true
  }
}
