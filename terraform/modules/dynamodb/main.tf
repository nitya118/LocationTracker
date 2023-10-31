  resource "aws_dynamodb_table" "this_dynamo_table" {
    
    name = var.ddb_name
    billing_mode = "PROVISIONED"
    read_capacity = 5
    write_capacity = 5

    hash_key = var.hash_key

    attribute {
      name = var.ddb_attribute_name
      type = var.ddb_attribute_type
    }

    dynamic "ttl" {
    for_each = var.enable_ttl ? [1] : []
    content {
      attribute_name = "TimeToLive"
      enabled        = true
    }
  }

  # adding resource tags
  tags = var.tags
  }