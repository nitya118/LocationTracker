variable "ddb_loc_report_arn"{
    type=string
    description="arn to the ddb_loc_report_arn dynamo db"
    default=""
}

variable "ddb_access_management_arn" {
    type=string
    description="arn to the ddb_access_management_arn dynamo db"
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

variable "asp_core_environment" {
  type = string
}