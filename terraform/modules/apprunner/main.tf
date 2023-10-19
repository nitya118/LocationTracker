

resource "aws_apprunner_auto_scaling_configuration_version" "app_runner_autoscaling" {
  auto_scaling_configuration_name = "MinConfiguration"
  max_concurrency = 100
  max_size        = 5
  min_size        = 1

  tags = {
    Name = "location-tracker"
  }
}



data "aws_iam_policy_document" "apprunner_service_instance_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["build.apprunner.amazonaws.com",
      "tasks.apprunner.amazonaws.com"  ]
    }
  }
}


resource "aws_iam_role" "apprunner_ecr_service_instance_role" {
  name = "apprunner-service-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.apprunner_service_instance_assume_policy.json
}


resource "aws_iam_policy" "ddb_table_policy" {
  name        = "ddb-location-reports-v2"
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

resource "aws_iam_role_policy_attachment" "apprunner_instance_role_attachment" {
  role       = aws_iam_role.apprunner_ecr_service_instance_role.name
  policy_arn = aws_iam_policy.ddb_table_policy.arn
}


resource "aws_iam_role_policy_attachment" "apprunner-service-role-attachment" {
  role       = aws_iam_role.apprunner_ecr_service_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "time_sleep" "waitrolecreate" {
depends_on = [aws_iam_role.apprunner_ecr_service_instance_role]
create_duration = "60s"
}





resource "aws_apprunner_service" "apprunner_backend" {

  depends_on = [time_sleep.waitrolecreate]

  service_name    = var.service_name

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.app_runner_autoscaling.arn

  instance_configuration {
    cpu     = 1024
    memory  = 2048
    instance_role_arn = aws_iam_role.apprunner_ecr_service_instance_role.arn
  }

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_service_instance_role.arn
    }

    image_repository {
      image_configuration {
        port = "80"
        runtime_environment_variables = {
          ASPNETCORE_ENVIRONMENT = var.asp_core_environment
          ASPNETCORE_FORWARDEDHEADERS_ENABLED	= true 
          }
      }
      image_identifier      = var.ecr_image_address
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true
  }
  # adding resource tags
  tags = var.tags
}
