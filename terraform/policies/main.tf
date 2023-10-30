data "aws_caller_identity" "current" {}


resource "aws_iam_policy" "paramemterstore-access-policy" {
  name        = "paramemterstore-access-policy"
  path        = "/"
  description = "Policy to access Parameter store"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Effect: "Allow",
            Action: [
                "ssm:GetParameters",
                "ssm:GetParameter",
            ],
            Resource: "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/*"
        }
    ]
})
}