data "archive_file" "lambda_deployment_package" {
  type        = "zip"
  output_path = "lambda_function.zip" # Replace with the desired output path

  source_dir = "../../../api/LocationTrackerAPI"  # Replace with the directory containing your lambda function code, e.g., your .NET 6 project
}

resource "aws_lambda_function" "lambda_function_v1" {
  function_name = var.function_name
  role          = var.lambda_execution_role_arn # Attach the IAM role here
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




