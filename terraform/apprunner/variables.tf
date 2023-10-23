variable "ddb_location-reports-arn"{
    type=string
    description="arn to the location reports dynamo db table"
    default=""
}

variable "ddb_users-arn"{
    type=string
    description="arn to the location reports dynamo db table"
    default=""
}

variable "image-path"{
    type=string
    description="image path"
    default=""
}