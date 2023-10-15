terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }

  backend "s3" {
    bucket                  = "tf-state-storage-dev02"
    key                     = "dev01/terraform.tfstate"
    region                  = "eu-west-1"
    dynamodb_table          = "tf-ddb-dev01"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

/*
resource "aws_s3_bucket" "content_bucket" {
  bucket = var.bucket_name
}
*/


resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.lambda_bucket_name
}


locals {
  tags = {
      Environment = "Dev"
      Owner       = "Platform"
      Cost_Center = 9999
    }
}

module "ecr_repo" {
  source             = "../../modules/ecr"
  aws_region         = var.aws_region
  ecr_repo_name      = "eu01-dev01-ecr01"
  //backend_image_name = "location-tracker"
  tags = local.tags
}


module "dynamodb_loc_report" {
  source = "../../modules/dynamodb"
  ddb_name = "eu01-dev01-ddb01"
  tags = local.tags
}

module "dynamodb_access_management" {
  source = "../../modules/dynamodb"
  ddb_name = "eu01-dev01-ddb02"
  tags = local.tags
}

output "dynamodb_instance" {
  value = module.dynamodb_loc_report.instance
}

output "dynamodb_instance2"{
    value=module.dynamodb_access_management.instance
}


module "apprunner" {
  source  = "../../modules/apprunner"
  ddb_loc_report_arn = module.dynamodb_loc_report.instance.arn
  ddb_access_management_arn = module.dynamodb_access_management.instance.arn
  asp_core_environment = "development"
  service_name = "eu01-dev01-app01"
  ecr_image_address = "007060634107.dkr.ecr.eu-west-1.amazonaws.com/eu01-dev01-ecr01:latest"
  tags = local.tags
}



module "front-end" {
  source      = "../../modules/front-end"
  website_root = "./front-end"
  domain_name  = "dev01.location-tracker.com"
  bucket_name_front_end = "dev01.location-tracker.com"

  tags = local.tags
}

output "website-url"{
  value=module.front-end.website_endpoint
}


module "api_lambda" {
  source = "../../modules/lambda"
  ddb_loc_report_arn = module.dynamodb_loc_report.instance.arn
  function_name = "loc_report_lambda_function"

  tags = local.tags
}




