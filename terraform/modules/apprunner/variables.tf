
variable "ecr_image_address" {
  description = "URL of your container image"
}

variable "service_name" {
  description = "Name of your App Runner service"
}

variable "tags" {
  type = map(string)
}

variable "asp_core_environment" {
  type = string
}

variable "apprunner_ecr_access_role_arn" {
  type = string
}

variable "apprunner_instance_role_arn" {
  type = string
}