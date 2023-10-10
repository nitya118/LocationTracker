

resource "aws_apprunner_service" "apprunner_backend" {
  service_name    = var.service_name

  instance_configuration {
    cpu     = 256
    memory  = 1024
  }

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_role.arn
    }

    image_repository {
      image_configuration {
        port = "8000"
      }
      image_identifier      = var.ecr_image_address
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true

  }

  tags = var.tags
}

resource "aws_iam_role" "apprunner_role" {
  name = "${var.service_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Effect": "Allow",
    "Principal": {
      "Service": "build.apprunner.amazonaws.com"
    }
  }]
}
EOF
}




resource "aws_iam_policy" "ddb-table-policy" {
  name        = "ddb-location-reports"
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
            Resource: var.ddb_loc_report_arn
        },
        {
            Sid: "",
            Effect: "Allow",
            Action: "dynamodb:*",
            Resource: var.ddb_access_management_arn
        }
    ]
})
}

# data "aws_iam_policy" "ddb-fullaccess-policy" {
#   name = "AmazonDynamoDBFullAccess"
# }

# data "aws_iam_policy" "apprunner-fullaccess-policy" {
#   name = "AWSAppRunnerFullAccess"
# }


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


resource "aws_iam_role_policy_attachment" "attach-ddb-table" {
  role       = aws_iam_role.apprunner-instance-role.name
  policy_arn = aws_iam_policy.ddb-table-policy.arn
}

/*Don't need full access*/
# resource "aws_iam_role_policy_attachment" "attach-ddb-fullaccess" {
#   role       = aws_iam_role.apprunner-instance-role.name
#   policy_arn = data.aws_iam_policy.ddb-fullaccess-policy.arn
# }

# resource "aws_iam_role_policy_attachment" "attach-apprunner-fullaccess" {
#   role       = aws_iam_role.apprunner-instance-role.name
#   policy_arn = data.aws_iam_policy.apprunner-fullaccess-policy.arn
# }

