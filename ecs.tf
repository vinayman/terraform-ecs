resource "aws_ecs_cluster" "main" {
  name = "hello-world-cluster"
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.app_name}-${var.app_environment}-logs"

  tags = {
    Application = var.app_name
    Environment = var.app_environment
  }
}

resource "aws_ecs_service" "hello_world" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.hello_world_task.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.hello_world_task.id]
    subnets         = aws_subnet.private.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.hello_world_tg.id
    container_name   = "hello-world-app"
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.hello_world]
}

resource "aws_ecs_task_definition" "hello_world_task" {
  family                   = "hello-world-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.hello_world_ecs_agent_task_exec_role.arn
  task_role_arn            = aws_iam_role.hello_world_ecs_agent_task_exec_role.arn

  container_definitions = <<DEFINITION
[
  {
    "image": "${local.app_image}",
    "cpu": 1024,
    "memory": 2048,
    "name": "hello-world-app",
    "networkMode": "awsvpc",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.log-group.id}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "${var.app_name}-${var.app_environment}",
        "awslogs-create-group": "true"
      }
    },
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ]
  }
]
DEFINITION
}

resource "aws_security_group" "hello_world_task" {
  name        = "hello-world-task-security-group"
  vpc_id      = aws_vpc.default.id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
