/*dynamo db*/

resource "aws_dynamodb_table" "location_report" {
  name           = "LocationReports"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Id"
  range_key      = "CreatedDateTimeUTC"

  attribute {
    name = "Id"
    type = "S"
  }

  attribute {
    name = "CreatedDateTimeUTC"
    type = "S"
  }

}