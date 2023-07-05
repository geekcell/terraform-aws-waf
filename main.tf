/**
 * # Terraform AWS WAF
 *
 * This Terraform module provides a preconfigured solution for setting up
 * AWS WAF in your AWS account. AWS WAF is a web application firewall that
 * helps protect your web applications from common web exploits that could
 * affect application availability, compromise security, or consume excessive
 * resources. With this Terraform module, you can easily and efficiently set
 * up and manage AWS WAF for your Load Balancer, API Gateway, or Cognito
 * User Pool.
 */
resource "aws_wafv2_web_acl" "main" {
  name        = local.prefix
  description = "Default Web ACL for ${var.name}"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "ip-blocking"
    priority = 0

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_blocking.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.prefix}-rule-ip-blocking"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "ip-rate-limit-for-api"
    priority = 1

    action {
      count {}
    }

    statement {
      rate_based_statement {
        aggregate_key_type = "FORWARDED_IP"
        limit              = 100

        forwarded_ip_config {
          fallback_behavior = "MATCH"
          header_name       = "X-Forwarded-For"
        }

        scope_down_statement {
          byte_match_statement {
            positional_constraint = "STARTS_WITH"
            search_string         = "/api/"

            field_to_match {
              uri_path {}
            }

            text_transformation {
              priority = 0
              type     = "URL_DECODE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.prefix}-rule-ip-rate-limit-for-api"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "ip-rate-limit-overall"
    priority = 2

    action {
      count {}
    }

    statement {
      rate_based_statement {
        aggregate_key_type = "FORWARDED_IP"
        limit              = 150

        forwarded_ip_config {
          fallback_behavior = "MATCH"
          header_name       = "X-Forwarded-For"
        }

        scope_down_statement {
          byte_match_statement {
            positional_constraint = "STARTS_WITH"
            search_string         = "/"

            field_to_match {
              uri_path {}
            }

            text_transformation {
              priority = 0
              type     = "URL_DECODE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.prefix}-rule-ip-rate-limit-overall"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesBotControlRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 5

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 6

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = 7

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesPHPRuleSet"
    priority = 8

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesPHPRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesPHPRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 9

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = local.prefix
    sampled_requests_enabled   = false
  }

  tags = var.tags
}

resource "aws_wafv2_ip_set" "ip_blocking" {
  name        = "${local.prefix}-ip-blocking"
  description = "IP blocking for ${local.prefix}"

  ip_address_version = "IPV4"
  scope              = "REGIONAL"

  addresses = []

  lifecycle {
    ignore_changes = [
      addresses
    ]
  }

  tags = var.tags
}

resource "aws_wafv2_web_acl_association" "main" {
  resource_arn = var.resource_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

locals {
  prefix = "${var.name}-web-acl"
}
