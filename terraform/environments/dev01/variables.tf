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
variable "lambda_bucket_name" {
  description = "S3 bucket for lambda deploy"
  type        = string
  default     = "eu01-s3-lambda-dev01"
}


/*
variable "ecr_image_address" {
  description = "URL of your container image"
}

variable "service_name" {
  description = "Name of your App Runner service"
}


variable "tags" {
  type = map(string)
}
*/