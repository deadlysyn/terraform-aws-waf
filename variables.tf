variable "association_arns" {
  description = "list of ARNs for ACL attachment"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "used to construct resource labels (dev, stage, prod)"
  type        = string
}

variable "common_ruleset_excludes" {
  description = "list of excluded rule names from common ruleset"
  type        = list(string)
  default     = [
    "GenericRFI_QUERYARGUMENTS",
    "EC2MetaDataSSRF_QUERYARGUMENTS",
    "EC2MetaDataSSRF_BODY",
    "SizeRestrictions_BODY",
    "CrossSiteScripting_QUERYARGUMENTS",
    "NoUserAgent_HEADER"
  ]
}

variable "namespace" {
  description = "used to construct resource labels"
  type        = string
}

variable "name" {
  description = "used to construct resource labels"
  type        = string
}

variable "tags" {
  description = "standard tags for all resources"
  type        = map(any)
}
