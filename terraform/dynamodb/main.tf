/*dynamo db*/

resource "aws_dynamodb_table" "location_report" {
  name           = "LocationReports"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Id"
  
  attribute {
    name = "Id"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToLive"
    enabled        = true
  }
}


  resource "aws_dynamodb_table" "users" {
  name           = "Users"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "UserName"
  
  attribute {
    name = "UserName"
    type = "S"
  }

  }

