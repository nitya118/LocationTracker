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