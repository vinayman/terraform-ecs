variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "app_count" {
  type = number
  default = 1
}

variable "app_name" {
  type = string
}

variable "app_environment" {
  type    = string
  default = "dev"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag (must exist in the ECR)"
}

variable "app_port" {
  type    = number
  default = 8000
}
