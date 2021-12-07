module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.25.0"
  namespace   = var.namespace
  environment = var.environment
  label_order = ["namespace", "name", "environment"]
  name        = var.name
  tags        = var.tags
}

resource "aws_wafv2_web_acl" "managed_rules" {
  name  = "${module.label.id}-managed-rules"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 5

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        dynamic "excluded_rule" {
          for_each = var.common_ruleset_excludes
          content {
            name = excluded_rule.value
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${module.label.id}-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 10

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
      metric_name                = "${module.label.id}-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 15

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
      metric_name                = "${module.label.id}-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesLinuxRuleSet"
    priority = 20

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
      metric_name                = "${module.label.id}-AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 25

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
      metric_name                = "${module.label.id}-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${module.label.id}-acl"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "managed_rules" {
  count        = length(var.association_arns) > 0 ? length(var.association_arns) : 0
  resource_arn = var.association_arns[count.index]
  web_acl_arn  = aws_wafv2_web_acl.managed_rules.arn
}
