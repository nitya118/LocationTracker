data "aws_dynamodb_table" "dynamodb_loc_report_arn" {
  name = "LocationReports"
}

data "aws_dynamodb_table" "dynamodb_users_arn" {
  name = "Users"
}

data "aws_ecr_repository" "ecr_repo_arn" {
  name = "eu01-dev01-ecr01"
}