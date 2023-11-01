terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }
# s3 for tf backend
  backend "s3" {
    bucket                  = "tf-state-storage-dev02"
    key                     = "dev01/backend_terraform.tfstate"
    region                  = "eu-west-1"
    dynamodb_table          = "tf-ddb-dev01"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

locals {
  tags = {
      Environment = "Dev"
      app       = "Geolocation"
    }
}


#create apprunner deployment 
module "apprunner" {
  source  = "../../../../terraform/modules/apprunner"
  apprunner_ecr_access_role_arn = data.aws_iam_role.apprunner_ecr_access_role_arn.arn
  apprunner_instance_role_arn = data.aws_iam_role.apprunner_instance_role_arn.arn
  asp_core_environment = "development"
  service_name = "eu01-dev01-app01"
  ecr_image_address = "${data.aws_ecr_repository.ecr_repo_arn.repository_url}:latest"

  tags = local.tags
}