data "aws_dynamodb_table" "dynamodb_loc_report_arn" {
  name = "eu01-dev01-ddb01"
}

data "aws_dynamodb_table" "dynamodb_users_arn" {
  name = "eu01-dev01-ddb02"
}

data "aws_ecr_repository" "ecr_repo_arn" {
  name = "eu01-dev01-ecr01"
}