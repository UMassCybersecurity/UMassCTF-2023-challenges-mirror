locals {
  cluster_name = "challenge_cluster-${var.name}"
  log_group    = "/ecs/${var.name}-log"
}

variable "name" {
  description = "The name of the resource(s) to be deployed"
  type        = string
}

# ECS Task Definition Variables
variable "arch" {
  description = "The architecture of the container(s) to run"
  type        = string
  default     = "X86_64"

  validation {
    condition     = var.arch == "X86_64" || var.arch == "ARM64"
    error_message = "Arch X86_64 or ARM is required"
  }
}

variable "cpu" {
  description = "The amount of CPU to allocate to the task definition"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "The amount of memory to allocate to the task definition"
  type        = string
  default     = "512"
}

variable "ecr_repo_name" {
  description = "The name of the ECR to pull images from"
  type        = string
}

variable "ecs_container_definition_envs" {
  description = "A list of the environment variables for the ECS container definition"
  type = list(object({
    name  = string
    value = string
  }))
}

variable "ecs_container_ports" {
  description = "A list of the port mappings"
  type = list(object({
    containerPort = number
    hostPort      = number
  }))
}
