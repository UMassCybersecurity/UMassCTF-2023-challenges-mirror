variable "name" {
  description = "The name of the project"
  type        = string
}

# VPC
variable "vpc_cidr" {
  description = "The CIDR for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}