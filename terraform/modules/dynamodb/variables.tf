variable "ddb_name" {
  type = string
}


variable "tags" {
  type = map(string)
}


variable "hash_key" {
  type = string
}

variable "ddb_attribute_name" {
  type = string
}

variable "ddb_attribute_type" {
  type = string
}

variable "enable_ttl" {
  description = "Enable or disable TTL"
  type        = bool
  default     = false
}