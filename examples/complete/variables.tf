#----------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# The module expects values to be supplied for these paramaters.
#----------------------------------------------------------------------------------------------------------------------
variable "region" {
  type        = string
  description = "AWS region"
}

#----------------------------------------------------------------------------------------------------------------------
# A list of standards/rulesets to enable
#
# See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription#argument-reference
#
# The possible values are:
#
#  - standards/aws-foundational-security-best-practices/v/1.0.0
#  - ruleset/cis-aws-foundations-benchmark/v/1.2.0
#  - standards/pci-dss/v/3.2.1
#----------------------------------------------------------------------------------------------------------------------
variable "enabled_standards" {
  description = "A list of standards to enable in the account"
  type        = list(string)
  default     = []
}

variable "create_sns_topic" {
  description = "Flag to indicate whether an SNS topic should be created for notifications."
  type        = bool
  default     = false
}
