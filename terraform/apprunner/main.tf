data "aws_caller_identity" "current" {}


resource "aws_apprunner_service" "location-tracker" {
  service_name = "location-tracker"

  source_configuration {
    authentication_configuration{
    access_role_arn=var.apprunner-ecr-access-role-arn
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
    instance_role_arn=var.apprunner-instance-role-arn
  }

  


}