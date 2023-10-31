variable "function_name" {
    type=string
    description="name of lambda function"
    default=""
}

variable "tags" {
  type = map(string)

}

variable "lambda_execution_role_arn" {
  type = string
}