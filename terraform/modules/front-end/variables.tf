variable "website_root" {
  type        = string
  description = "Path to the root of website content"
}

variable "domain_name" {
  type = string
  description = "Name of the domain"
}
variable "bucket_name_front_end" {
  type = string
  description = "Name of the bucket."
}

variable "tags" {
  type = map(string)

}