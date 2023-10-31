data "aws_caller_identity" "current" {}


resource "aws_iam_policy" "paramemterstore-access-policy" {
  name        = "paramemterstore-access-policy"
  path        = "/"
  description = "Policy to access Parameter store"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Effect: "Allow",
            Action: [
                "ssm:GetParameters",
                "ssm:GetParameter",
            ],
            Resource: "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/*"
        }
    ]
})
}




resource "aws_iam_policy" "sns_publish_policy" {
  name        = "sns_publish_policy"
  path        = "/"
  description = "Policy to allow sms publishing for the current account"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": "*"
        }
    ]
})
}




resource "aws_iam_policy" "ddb-location-reports-policy" {
  name        = "ddb-location-reports-policy"
  path        = "/"
  description = "Policy to access dynamodb"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Sid: "",
            Effect: "Allow",
            Action: "dynamodb:*",
            Resource: var.ddb_location_reports_arn
        }
    ]
})
}

resource "aws_iam_policy" "ddb-users-policy" {
  name        = "ddb-users-policy"
  path        = "/"
  description = "Policy to access dynamodb"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Sid: "",
            Effect: "Allow",
            Action: "dynamodb:*",
            Resource: var.ddb_users_arn
        }
    ]
})
}


