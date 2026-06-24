variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "The environment name (staging or production)"
  type        = string
  default     = "staging"
}

variable "instance_size" {
  description = "The EC2 instance type for ECS cluster"
  type        = string
  default     = "t3.small"
}

variable "ecs_desired_capacity" {
  description = "The desired number of ECS instances"
  type        = number
  default     = 3
}