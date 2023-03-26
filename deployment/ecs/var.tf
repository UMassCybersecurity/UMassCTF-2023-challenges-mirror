locals {
  cluster_name = "challenge_cluster-${var.name}"
}

variable "name" {
  description = "The name of the resource(s) to be deployed"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "ports" {
  description = "The port(s) to open"
  type        = list(number)
}

variable "task_definition_arn" {
  description = "The ARN of the Task Definition"
  type        = string
}

# Security Group Variables
variable "security_groups" {
  description = "The security groups to create"
  type        = string
}

# ECS Service Variables
variable "desired_count" {
  description = "The amount of instances to start with/are desired"
  type        = number
  default     = 3
}

variable "subnet" {
  description = "The subnet to host the service"
  type        = string
}

variable "load_balancer" {
  description = "Whether to use a load balancer or not"
  type        = bool
  default     = true
}

variable "auto_scaling" {
  description = "Whether to use an auto scaler or not"
  type        = bool
  default     = true
}