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

variable "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the resource to associate with the web ACL. This must be an ARN of an Application Load Balancer, an Amazon API Gateway stage, or an Amazon Cognito User Pool."
  type        = string
}
