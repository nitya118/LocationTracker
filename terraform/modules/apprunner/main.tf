

resource "aws_apprunner_auto_scaling_configuration_version" "app_runner_autoscaling" {
  auto_scaling_configuration_name = "MinConfiguration"
  max_concurrency = 100
  max_size        = 5
  min_size        = 1

  tags = {
    Name = "location-tracker"
  }
}


resource "aws_apprunner_service" "apprunner_backend" {

  depends_on = [time_sleep.waitrolecreate]

  service_name    = var.service_name

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.app_runner_autoscaling.arn

  instance_configuration {
    cpu     = 1024
    memory  = 2048
    instance_role_arn = var.apprunner_instance_role_arn
  }

  source_configuration {
    authentication_configuration {
      access_role_arn = var.apprunner_ecr_access_role_arn
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
