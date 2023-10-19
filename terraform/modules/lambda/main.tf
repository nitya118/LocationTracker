resource "aws_iam_role" "lambda_execution_role" {
  name = "LambdaDynamoAccessRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "basic_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_iam_policy" "dynamodb_table_policy" {
  name        = "DynamoDBTablePolicy"
  description = "Provides read/write access to the DynamoDB table"

  policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": var.ddb_loc_report_arn
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "dynamodb_table_policy_attachment" {
  policy_arn = aws_iam_policy.dynamodb_table_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}



data "archive_file" "lambda_deployment_package" {
  type        = "zip"
  output_path = "lambda_function.zip" # Replace with the desired output path

  source_dir = "../../../api/LocationTrackerAPI"  # Replace with the directory containing your lambda function code, e.g., your .NET 6 project
}

resource "aws_lambda_function" "lambda_function_v1" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_execution_role.arn # Attach the IAM role here
  runtime       = "dotnet6"
  handler       = "LocationTrackerAPI::LocationTrackerAPI.Functions::LocationReport"

  filename         = data.archive_file.lambda_deployment_package.output_path
  source_code_hash = data.archive_file.lambda_deployment_package.output_base64sha256
  #adding resource tags
  tags = var.tags 

}


resource "aws_lambda_function_url" "lambda_function_expose" {
  function_name      = aws_lambda_function.lambda_function_v1.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
  }
}




