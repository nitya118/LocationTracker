resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Effect: "Allow",
            Principal: {
                Service: "lambda.amazonaws.com"
            },
            Action: "sts:AssumeRole"
        }
    ]
})
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



data "aws_iam_policy" "AppRunnerECRAcessPolicy" {
  name = "AWSAppRunnerServicePolicyForECRAccess"
}


resource "aws_iam_role_policy_attachment" "lambda-attach-policy-parameter-store" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = var.parameterstore_access_policy_arn
}

resource "aws_iam_role_policy_attachment" "lambda-attach-policy-ddb-location-reports" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = var.location_reports_table_access_policy_arn
}



resource "aws_iam_role_policy_attachment" "attach-policy-apprunner-ecr-access" {
  role       = aws_iam_role.apprunner-ecr-access-role.name
  policy_arn = data.aws_iam_policy.AppRunnerECRAcessPolicy.arn
}


resource "aws_iam_role_policy_attachment" "attach-policy-ddb-location-reports" {
  role       = aws_iam_role.apprunner-instance-role.name
  policy_arn = var.location_reports_table_access_policy_arn
}


resource "aws_iam_role_policy_attachment" "attach-policy-ddb-users" {
  role       = aws_iam_role.apprunner-instance-role.name
  policy_arn = var.users_table_access_policy_arn
}


resource "aws_iam_role_policy_attachment" "attach-policy-sns-publish" {
  role       = aws_iam_role.apprunner-instance-role.name
  policy_arn = var.sns_access_policy_arn
}


resource "aws_iam_role_policy_attachment" "attach-policy-parameter-store" {
  role       = aws_iam_role.apprunner-instance-role.name
  policy_arn = var.parameterstore_access_policy_arn
}


