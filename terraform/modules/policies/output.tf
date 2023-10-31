output "instance_parameter_store_access_policy"{
    value=aws_iam_policy.paramemterstore-access-policy
}


output "instance_sns_access_policy"{
    value=aws_iam_policy.sns_publish_policy
}

output "instance_location_reports_table_access_policy"{
    value=aws_iam_policy.ddb-location-reports-policy
}

output "instance_users_table_access_policy"{
    value=aws_iam_policy.ddb-users-policy
}