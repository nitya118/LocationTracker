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
      Owner       = "Platform"
      Cost_Center = 0000
    }
}


#create apprunner deployment 
module "apprunner" {
  source  = "../../../../terraform/modules/apprunner"
  ddb_loc_report_arn = data.aws_dynamodb_table.dynamodb_loc_report_arn.arn
  ddb_access_management_arn = data.aws_dynamodb_table.dynamodb_users_arn.arn
  asp_core_environment = "development"
  service_name = "eu01-dev01-app01"
  ecr_image_address = "${data.aws_ecr_repository.ecr_repo_arn.repository_url}/:latest"

  tags = local.tags
}