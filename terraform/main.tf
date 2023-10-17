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
/*
resource "aws_s3_bucket" "content_bucket" {
  bucket = var.bucket_name
}
*/


module "ecr_repo" {
  source             = "./ecr"
  aws_region         = var.aws_region
  ecr_repo_name      = "location-tracker"
  backend_image_name = "location-tracker"
}




module "dynamodb" {
  source = "./dynamodb"
}

output "test" {
  value = module.dynamodb.instance
}


module "apprunner" {
  source  = "./apprunner"
  ddb_arn = module.dynamodb.instance.arn
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



