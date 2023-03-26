# Cluster
resource "aws_ecs_cluster" "cluster" {
  name = local.cluster_name
}

# Service
resource "aws_ecs_service" "service" {
  name            = var.name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count

  lifecycle {
    ignore_changes = [desired_count]
  }

  network_configuration {
    subnets          = [var.subnet]
    security_groups  = [var.security_groups]
    assign_public_ip = true
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 4
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }

  dynamic "load_balancer" {
    for_each = [for port in var.ports : port if var.load_balancer]
    content {
      container_name   = var.name
      container_port   = load_balancer.value
      target_group_arn = aws_lb_target_group.target_group[index(var.ports, load_balancer.value)].arn
    }
  }
}
