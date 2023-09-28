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
  aws_region             =  var.aws_region
  ecr_repo_name      = "location-tracker"
  backend_image_name = "location-tracker"
}

output "test"{
  value=module.ecr_repo.ecr_instance
}


resource "aws_dynamodb_table" "location" {
  name           = "LocationReports"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Id"
  range_key      = "DateTimeUTC"

  attribute {
    name = "Id"
    type = "S"
  }

  attribute {
    name = "DateTimeUTC"
    type = "N"
  }

}


