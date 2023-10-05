/*dynamo db*/

resource "aws_dynamodb_table" "location_report" {
  name           = var.ddb_loc_report_name
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
    type = "S"
  }
}

resource "aws_dynamodb_table" "access_management" {
  name           = var.ddb_access_management_name
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
    type = "S"
  }
}