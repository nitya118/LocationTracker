#terraform config for staging environment

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }
# s3 for tf backend
  backend "s3" {
    bucket                  = "tf-state-storage-stg01"
    key                     = "stg01/terraform.tfstate"
    region                  = "eu-west-1"
    dynamodb_table          = "tf-ddb-stg01"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

locals {
  tags = {
      Environment = "stage"
      Owner       = "Platform"
      Cost_Center = 9999
    }
}
# ecr repo for backend docker image
module "ecr_repo" {
  source             = "../../modules/ecr"
  aws_region         = var.aws_region
  ecr_repo_name      = "eu01-stg01-ecr01"
  //backend_image_name = "location-tracker"
  tags = local.tags
}

#dynamo db module
module "dynamodb_loc_report" {
  source = "../../modules/dynamodb"
  ddb_name = "eu01-stg01-ddb01"
  tags = local.tags
}

module "dynamodb_access_management" {
  source = "../../modules/dynamodb"
  ddb_name = "eu01-stg01-ddb02"
  tags = local.tags
}

output "dynamodb_instance" {
  value = module.dynamodb_loc_report.instance
}

output "dynamodb_instance2"{
    value=module.dynamodb_access_management.instance
}

#create apprunner deployment 
module "apprunner" {
  source  = "../../modules/apprunner"
  ddb_loc_report_arn = module.dynamodb_loc_report.instance.arn
  ddb_access_management_arn = module.dynamodb_access_management.instance.arn
  asp_core_environment = "development"
  service_name = "eu01-stg01-app01"
  ecr_image_address = "007060634107.dkr.ecr.eu-west-1.amazonaws.com/eu01-stg01-ecr01:latest"
  tags = local.tags
}



module "front-end" {
  source      = "../../modules/front-end"
  website_root = "./front-end"
  domain_name  = "stg01.location-tracker.com"
  bucket_name_front_end = "stg01.location-tracker.com"

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




