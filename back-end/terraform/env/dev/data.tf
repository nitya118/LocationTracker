data "aws_ecr_repository" "ecr_repo_arn" {
  name = "eu01-dev01-ecr01"
}

data "aws_iam_role" "apprunner_ecr_access_role_arn" {
  name = "apprunner-ecr-access-role"
}

data "aws_iam_role" "apprunner_instance_role_arn" {
  name = "apprunner-instance-role"
}

