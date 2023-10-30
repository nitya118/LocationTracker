resource "aws_ssm_parameter" "map_name" {
  name  = "map_name"
  type  = "String"
  value = "quick-start-using-cognito-example"
}

resource "aws_ssm_parameter" "map_pool_id" {
  name  = "map_pool_id"
  type  = "String"
  value = "eu-west-1:478a32d0-58df-414f-a4f2-e2e58c300742"
}

resource "aws_ssm_parameter" "map_region" {
  name  = "map_region"
  type  = "String"
  value = "eu-west-1"
}