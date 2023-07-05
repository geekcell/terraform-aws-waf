# Context
variable "tags" {
  default     = {}
  description = "Tags to add to the Resources."
  type        = map(any)
}

# AWS Web Application Firewall
variable "name" {
  description = "Friendly name of the rule."
  type        = string
}

variable "rate_limit_positional_constraint" {
  description = "The area within the portion of a web request that you want AWS WAF to search for rate limiting headers. Valid values: EXACTLY, STARTS_WITH, ENDS_WITH, CONTAINS, and CONTAINS_WORD. The default value is EXACTLY."
  default     = "STARTS_WITH"
  type        = string
}

variable "rate_limit_search_string" {
  description = "String value that you want AWS WAF to search for. AWS WAF searches only in the part of web requests that you designate for inspection in field_to_match. The maximum length of the value is 50 bytes."
  default     = "/api"
  type        = string
}

variable "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the resource to associate with the web ACL. This must be an ARN of an Application Load Balancer, an Amazon API Gateway stage, or an Amazon Cognito User Pool."
  type        = string
}
