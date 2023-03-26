locals {
  purpose     = "umass_ctf"
  subnet_name = "${var.name}-subnet"
}

variable "name" {
  description = "The name of the project"
  type        = string
}

# VPC
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

# Subnet
variable "subnet" {
  description = "The CIDR for the subnet"
  type        = string
}

variable "route_table_id" {
  description = "The route table to associate the subnet with"
  type        = string
}

# Security Group
variable "ports" {
  description = "The ports to open"
  type        = list(number)
}
