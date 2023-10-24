
variable "ecr_repo_name"{
    type=string
    default="location-tracker-repo"
}
#check
variable "untagged_images"{
  type=number
  default=1
}

#variable "backend_image_name"{
#	type=string
#	default="location-tracker"
#}


variable "aws_region"{
    type=string
    default="eu-west-1"
}

variable "tags" {
  type = map(string)
}