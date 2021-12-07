# terraform-aws-waf

[AWS WAF](https://docs.aws.amazon.com/waf)
is extremely powerful and flexible, but some times you don't need
the cognitive load of all that flexibility to benefit from much of the power!

If you have a very specific use case requiring a lot of custom rules, you
are better off building from scratch or using [cloudposse/terraform-aws-waf](https://github.com/cloudposse/terraform-aws-waf).

If you have fairly standard web services and want to bolt on an
[AWS-managed set of protections](https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html),
this module can save you time.

## Usage

**NOTE:** You should always pin to a specific version.

```hcl
module "waf" {
  source                  = "git::ssh://git@github.com/sonatype/terraform-aws-waf.git?ref=v0.0.1"
  association_arns        = [module.foo.alb_arn]
  environment             = var.environment
  name                    = var.name
  namespace               = var.namespace
  tags                    = var.tags

  # these have caused problems for legitimate queries, YMMV
  common_ruleset_excludes = [
    "GenericRFI_QUERYARGUMENTS",
    "EC2MetaDataSSRF_QUERYARGUMENTS",
    "EC2MetaDataSSRF_BODY",
    "SizeRestrictions_BODY",
    "CrossSiteScripting_QUERYARGUMENTS",
    "NoUserAgent_HEADER"
  ]
}
```

## Inputs

| Name                      | Description                       |  Type                | Required | Notes    |
| ------------------------- | --------------------------------- | :------------------: | :------: | :--------|
| association\_arns         | List of ARNs for ACL attachment   | list(string)         | yes      | |
| common\_ruleset\_excludes | Environment name                  | list(string)         | no       | label format: namespace-name-environment |
| environment               | Environment name                  | string               | yes      | |
| name                      | Used to construct resource labels | string               | yes      | |
| namespace                 | Used to construct resource labels | string               | yes      | |
| tags                      | Tags applied to resources         | object[string]string | yes      | |
