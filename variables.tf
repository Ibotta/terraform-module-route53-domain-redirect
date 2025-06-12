variable "zone" {
  description = "Route53 zone name"
  type        = string
}

variable "target_url" {
  description = "URL to redirect to"
  type        = string
  default     = null
}

variable "source_subdomain" {
  description = "FQDN of subdomain that we want to redirect from."
  type        = string
  default     = ""
}

variable "allow_overwrite" {
  description = "Allow route53 to overwrite the current rule"
  type        = bool
  default     = false
}

variable "remove_trailing_slash" {
  description = "Remove trailing slash automatically added by S3 to the target URL. Conflicts with target_url."
  type        = map(string)
  default     = {}
}

variable "ttl" {
  description = "TTL object to hold the TTL values for min, max and default for the record."
  type = object({
    min     = number
    max     = number
    default = number
  })
  default = {
    min     = 31536000
    max     = 31536000
    default = 31536000
  }
}

variable "tags" {
  type = map(string)
}
