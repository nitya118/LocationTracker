output "instance_apprunner_instance_role"{
    value=aws_iam_role.apprunner-instance-role
}


output "instance_apprunner_ecr_access_role"{
    value=aws_iam_role.apprunner-ecr-access-role
}

output "lambda_role" {
  value = aws_iam_role.lambda_role
}