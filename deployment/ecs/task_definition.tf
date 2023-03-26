#resource "aws_ecs_task_definition" "ctfd_task_definition" {
#  family                   = var.name
#  requires_compatibilities = ["FARGATE"]
#  network_mode             = "awsvpc"
#
#  runtime_platform {
#    cpu_architecture = var.arch
#  }
#
#  execution_role_arn = aws_iam_role.ecsTaskExecutionRoleECSCluster.arn
#
#  cpu    = var.cpu
#  memory = var.memory
#
#  container_definitions = jsonencode([
#    {
#      name      = var.name
#      image     = data.aws_ecr_repository.ecr.repository_url
#      cpu       = parseint(var.cpu, 10)
#      memory    = parseint(var.memory, 10)
#      essential = true
#      logConfiguration = {
#        "logDriver" : "awslogs",
#        "options" : {
#          "awslogs-group" : local.log_group,
#          "awslogs-region" : "us-east-1",
#          "awslogs-stream-prefix" : "ecs"
#        }
#      }
#      environment  = var.ecs_container_definition_envs
#      portMappings = var.ecs_container_ports
#    }
#    ]
#  )
#}