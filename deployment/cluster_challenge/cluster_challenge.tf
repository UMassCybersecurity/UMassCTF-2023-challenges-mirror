module "network" {
  source         = "../network/"
  name           = var.name
  vpc_id         = var.vpc_id
  ports          = var.ports
  route_table_id = var.route_table_id
  subnet         = var.subnet
}

module "task_definition" {
  source = "../ecs_task_definition"

  ecr_repo_name                 = var.ecr_repo
  arch                          = var.arch
  cpu                           = var.cpu
  memory                        = var.memory
  ecs_container_definition_envs = var.container_env
  ecs_container_ports           = var.container_ports
  name                          = var.name
}

module "cluster" {
  source              = "../ecs/"
  name                = var.name
  task_definition_arn = module.task_definition.task_definition_arn
  ports               = var.ports
  security_groups     = module.network.security_group_id
  desired_count       = var.desired_count
  subnet              = module.network.subnet_id
  vpc_id              = var.vpc_id
  load_balancer       = var.load_balancer
  auto_scaling        = var.auto_scaling
}
