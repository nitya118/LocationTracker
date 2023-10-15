variable "ddb_loc_report_arn"{
    type=string
    description="arn to the ddb_loc_report_arn dynamo db"
    default=""
}

variable "function_name" {
    type=string
    description="name of lambda function"
    default=""
}

variable "tags" {
  type = map(string)

}