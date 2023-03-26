variable "name" {
  description = "The name of the cache"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "subnet" {
  description = "The subnet accessing the cache"
  type        = string
}

variable "subnet1" {
  description = "The first subnet"
  type        = string
}

variable "subnet2" {
  description = "The second subnet"
  type        = string
}

variable "route_table_id" {
  description = "The ID of the route table"
  type        = string
}

variable "username" {
  description = "The username of the DB"
  type        = string
}

variable "password" {
  description = "The password of the DB"
  type        = string
}