resource "aws_lambda_function" "dev_lambda"{
  function_name    = "dev_lambda_function"
  role             = aws_iam_role.example_role.arn
  handler          = "LocationTrackerAPI::LocationTrackerAPI.Functions_Get_Generated::Get"
  runtime          = "Node.js 18"
  filename         = "location_tracker.zip"
  source_code_hash = filebase64sha256("location_tracker.zip")
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_iam_role"

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

resource "aws_iam_policy" "ddb-access-table-policy" {
  name        = "ddb-access-management"
  path        = "/"
  description = "Policy to access dynamodb"
    # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Sid: "",
            Effect: "Allow",
            Action: "dynamodb:*",
            Resource: var.ddb_arn_am
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "my_lambda_function_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy_attachment" "my_lambda_function_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.ddb-access-table-policy.arn
}