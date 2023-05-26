module "example" {
  source       = "../../"
  name         = "waf"
  resource_arn = "arn:aws:elasticloadbalancing:eu-central-1:123456789012:loadbalancer/app/my-load-balancer/1234567890123456"
}
