data "aws_caller_identity" "current" {}



resource "aws_iam_policy" "sns-publish-policy" {
  name        = "sns-publish-policy"
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
            Resource: var.ddb_location-reports-arn
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
            Resource: var.ddb_users-arn
        }
    ]
})
}


data "aws_iam_policy" "AppRunnerECRAcessPolicy" {
  name = "AWSAppRunnerServicePolicyForECRAccess"
}




resource "aws_iam_role" "apprunner-instance-role" {
  name = "apprunner-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
             "ec2.amazonaws.com",
             "tasks.apprunner.amazonaws.com"
          ]
        }
      },
    ]
  })
}

resource "aws_iam_role" "apprunner-ecr-access-role" {
  name = "apprunner-ecr-access-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "build.apprunner.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "attach-policy-apprunner-ecr-access" {
  role       = aws_iam_role.apprunner-ecr-access-role.name
  policy_arn = data.aws_iam_policy.AppRunnerECRAcessPolicy.arn
}


resource "aws_iam_role_policy_attachment" "attach-policy-ddb-location-reports" {
  role       = aws_iam_role.apprunner-instance-role.name
  policy_arn = aws_iam_policy.ddb-location-reports-policy.arn
}


resource "aws_iam_role_policy_attachment" "attach-policy-ddb-users" {
  role       = aws_iam_role.apprunner-instance-role.name
  policy_arn = aws_iam_policy.ddb-users-policy.arn
}


resource "aws_iam_role_policy_attachment" "attach-policy-sns-publish" {
  role       = aws_iam_role.apprunner-instance-role.name
  policy_arn = aws_iam_policy.sns-publish-policy.arn
}




resource "aws_apprunner_service" "location-tracker" {
  service_name = "location-tracker"

  source_configuration {
    authentication_configuration{
    access_role_arn=aws_iam_role.apprunner-ecr-access-role.arn
  }

    image_repository {
      image_configuration {
        port = "80"
        runtime_environment_variables = {
          "ASPNETCORE_ENVIRONMENT" = "Development"
          "ASPNETCORE_FORWARDEDHEADERS_ENABLED" = "true"
        }
      }
      image_identifier      = "${var.image-path}:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = false
  }

  instance_configuration{
    cpu=1024
    memory=2048
    instance_role_arn=aws_iam_role.apprunner-instance-role.arn
  }

  


}