variable "aws_region" {
  type    = "string"
  default = "us-west-2"
}

variable "service" {
  type    = "string"
  default = "ghost"
}

variable "service_stage" {
  type    = "string"
  default = "dev"
}

variable "service_instance" {
  type    = "string"
  default = "awshonolulu"
}

variable "aws_profile" {
  type    = "string"
  default = "awshonolulu"
}

variable "vpc_cidr" {
  description = "VPC CIDR to use. Defaults to 10.0.0.0/16"
  type        = "string"
  default     = "10.0.0.0/16"
}

variable "vpc_private_subnets" {
  description = "Private subnets cidrs to create."
  type        = "list"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets cidrs to create."
  type        = "list"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  description = "AWS region to launch servers; if not set the available zones will be detected automatically"
  type        = "list"
  default     = ["us-west-2a", "us-west-2b"]
}