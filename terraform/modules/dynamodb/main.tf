/*dynamo db*/

resource "aws_dynamodb_table" "ddb_table" {
  name           = var.ddb_name
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

  tags = var.tags
}