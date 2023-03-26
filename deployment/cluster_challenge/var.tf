variable "ctf" {
  description = "The generic name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "route_table_id" {
  description = "The ID of the route table"
  type        = string
}

variable "arch" {
  description = "The architecture of the container(s) to run"
  type        = string
  default     = "X86_64"

  validation {
    condition     = var.arch == "X86_64" || var.arch == "ARM64"
    error_message = "Arch X86_64 or ARM is required"
  }
}

variable "name" {
  description = "The name of the challenge"
  type        = string
}

variable "cpu" {
  description = "The amount of CPU to allocate to the task definition"
  type        = string
  default     = "1024"
}

variable "memory" {
  description = "The amount of memory to allocate to the task definition"
  type        = string
  default     = "2048"
}

variable "ecr_repo" {
  description = "The ECR repo"
  type        = string
}

variable "ports" {
  description = "The port(s) to open"
  type        = list(number)
}

variable "desired_count" {
  description = "The amount of instances to start with/are desired"
  type        = number
  default     = 3
}

variable "subnet" {
  description = "The subnet to host the service"
  type        = string
}

variable "container_env" {
  description = "A list of the environment variables for the ECS container definition"
  type = list(object({
    name  = string
    value = string
  }))
}

variable "container_ports" {
  description = "A list of the port mappings"
  type = list(object({
    containerPort = number
    hostPort      = number
  }))
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