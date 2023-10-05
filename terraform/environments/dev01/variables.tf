variable "aws_region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS Region Ireland"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "locationservice-content"
}


variable "ecr_image_address" {
  description = "URL of your container image"
}

variable "service_name" {
  description = "Name of your App Runner service"
}

variable "tags" {
  type = map(string)
}
