#-----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults set that can be overridden for desired behavior.
#-----------------------------------------------------------------------------------------------------------------------

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
  type        = list
  default     = []
}


#-----------------------------------------------------------------------------------------------------------------------
# If you want to send findings to a new SNS topic, set create_sns_topic to true and provide a valid configuration for 
# subscribers
#-----------------------------------------------------------------------------------------------------------------------
variable "create_sns_topic" {
  description = "Flag to indicate whether an SNS topic should be created for notifications."
  type        = bool
  default     = false
}

#-----------------------------------------------------------------------------------------------------------------------
# A map of subscription configurations for SNS topics
# 
# For more information, see:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#argument-reference
# 
# protocol:         
#   The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially 
#   supported, see link) (email is an option but is unsupported in terraform, see link).
# 
# endpoint:         
#   The endpoint to send data to, the contents will vary with the protocol. (see link for more information)
#
# endpoint_auto_confirms:
#   Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty. Default is false
#-----------------------------------------------------------------------------------------------------------------------
variable "subscribers" {
  type = map(object({
    protocol               = string
    endpoint               = string
    endpoint_auto_confirms = bool
  }))
  description = <<-
    Configuration for subscibres to SNS topic. This is only used if create_sns_topic is true.
    A map of subscription configurations for SNS topics

   For more information, see:
     https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#argument-reference
   etc....
  default     = {}
}

#-----------------------------------------------------------------------------------------------------------------------
# If you want to send findings to an existing SNS topic, set the value of imported_findings_notification_arn to the ARN 
# of the existing topic and set create_sns_topic to false.
#-----------------------------------------------------------------------------------------------------------------------
variable "imported_findings_notification_arn" {
  description = "The ARN for an SNS topic to send findings notifications to. This is only used if create_sns_topic is false."
  default     = null
  type        = string
}


