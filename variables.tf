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
  default     = ""
  type        = string
}

variable "allow_overwrite" {
  description = "Allow route53 to overwrite the current rule"
  default     = false
  type        = bool
}

variable "remove_trailing_slash" {
  description = "Remove trailing slash automicatically added by S3 to the target URL. Conflicts with target_url."
  type        = map(string)
  default     = {}
}

variable "tags" {
  type = map(string)
}