
terraform {
  required_version = ">=0.13.0"

  required_providers {
    aws = {}
  }

  backend "s3" {
    bucket = "you-speak-yoda-terraform"
    key    = "yodaspeak-fargate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = var.region
}


# ------------------------------------------
# IAM
# ------------------------------------------

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.app_name}-ecs"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ------------------------------------------
# ECS
# ------------------------------------------

resource "aws_ecs_cluster" "this" {
  name = "yodaspeak-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = templatefile(
    "${path.module}/resources/task_definition.json",
    {
      region        = var.region,
      app_name      = var.app_name,
      cpu           = var.cpu,
      memory        = var.memory,
      port          = var.port,
      tls_port      = var.tls_port,
      doppler_token = var.doppler_token
    }
  )

  depends_on = [aws_cloudwatch_log_group.this]
}

resource "aws_ecs_service" "main" {
  name            = "${var.app_name}-ecs-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = "1"
  launch_type     = "FARGATE"


  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = [var.subnet_id]
    assign_public_ip = true
  }
}


# ------------------------------------------
# OTHER
# ------------------------------------------

resource "aws_security_group" "this" {
  name        = "${var.app_name}-fargate-sg"
  description = "Allow all inbound traffic on 80 and 443"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.app_name}-sg"
  }

  ingress {
    from_port = var.port
    to_port   = var.port
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = var.tls_port
    to_port   = var.tls_port
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/fargate/service/${var.app_name}"
}