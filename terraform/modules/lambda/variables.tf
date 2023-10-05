variable lambda-name {
  type        = string
  default     = ""
  description = "name of the lambda"
}

variable source-directory{
  type =string
  description ="source code path"
}

variable build-artifact-bucket-id{
  type=string
  description="s3 bucket where the build artifacts are pushed into"
}

variable "ddb_arn_am" {
  type = string
}