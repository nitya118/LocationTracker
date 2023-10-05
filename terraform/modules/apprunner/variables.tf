variable "ddb_arn"{
    type=string
    description="arn to the dynamo db"
    default=""
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