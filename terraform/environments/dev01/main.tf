#terraform config for dev environment

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
    key                     = "dev01/terraform.tfstate"
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

module "parameterstore"{
  source="../../modules/parameterstore"
}



# ecr repo for backend docker image
module "ecr_repo" {
  source             = "../../modules/ecr"
  aws_region         = var.aws_region
  ecr_repo_name      = "eu01-dev01-ecr01"
  //backend_image_name = "location-tracker"
  tags = local.tags
}

#dynamo db module
module "dynamodb_loc_report" {
  source = "../../modules/dynamodb"
  ddb_name = "LocationReports"
  hash_key = "Id"

  ddb_attribute_name = "Id"
  ddb_attribute_type = "S"

  enable_ttl = true

  tags = local.tags
}

#dynamodb_access_management
module "dynamodb_users" {
  source = "../../modules/dynamodb"
  ddb_name = "Users"
  hash_key = "UserName"

  ddb_attribute_name = "UserName"
  ddb_attribute_type = "S"
  tags = local.tags
}

output "dynamodb_instance" {
  value = module.dynamodb_loc_report.instance
}

output "dynamodb_instance2"{
    value=module.dynamodb_users.instance
}

module "policies"{
  source="../../modules/policies"
  ddb_location_reports_arn = module.dynamodb_loc_report.instance.arn
  ddb_users_arn=module.dynamodb_users.instance.arn
}

output "test" {
  value = module.policies.instance_parameter_store_access_policy
}

module "roles"{
  source="../../modules/roles"
  parameterstore_access_policy_arn=module.policies.instance_parameter_store_access_policy.arn
  location_reports_table_access_policy_arn=module.policies.instance_location_reports_table_access_policy.arn
  users_table_access_policy_arn=module.policies.instance_users_table_access_policy.arn
  sns_access_policy_arn=module.policies.instance_sns_access_policy.arn

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
  function_name = "loc_report_lambda_function"
  lambda_execution_role_arn = module.roles.lambda_role.arn
  tags = local.tags
}




