terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}


module "parameterstore"{
  source="./parameterstore"
}


module "ecr_repo" {
  source             = "./ecr"
  aws_region         = var.aws_region
  ecr_repo_name      = "location-tracker"
  backend_image_name = "location-tracker"
}




module "dynamodb" {
  source = "./dynamodb"
}


module "policies"{
  source="./policies"
  ddb_location-reports-arn = module.dynamodb.instance_location_report.arn
  ddb_users-arn=module.dynamodb.instance_users.arn
}

output "test" {
  value = module.policies.instance_parameter_store_access_policy
}

module "roles"{
  source="./roles"
  parameterstore-access-policy-arn=module.policies.instance_parameter_store_access_policy.arn
  location-reports-table-access-policy-arn=module.policies.instance_location_reports_table_access_policy.arn
  users-table-access-policy-arn=module.policies.instance_users_table_access_policy.arn
  sns-access-policy-arn=module.policies.instance_sns_access_policy.arn

}


module "apprunner" {
  source  = "./apprunner"
  apprunner-instance-role-arn=module.roles.instance_apprunner_instance_role.arn
  apprunner-ecr-access-role-arn=module.roles.instance_apprunner_ecr_access_role.arn
  image-path=module.ecr_repo.instance.repository_url
}


module "front-end" {
  source       = "./front-end"
  website_root = "./front-end"
  domain_name  = "location-tracker.com"
  bucket_name  = "location-tracker.com"
}

output "website-url" {
  value = module.front-end.website_endpoint
}



