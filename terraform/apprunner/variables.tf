
variable "image-path"{
    type=string
    description="image path"
    default=""
}

variable "apprunner-instance-role-arn"{
    type=string
    description="arn of the instance role"
    default=""
}

variable "apprunner-ecr-access-role-arn"{
    type=string
    description="arn of the instance role"
    default=""
}