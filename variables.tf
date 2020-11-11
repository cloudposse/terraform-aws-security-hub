#-----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults set that can be overridden for desired behavior.
#-----------------------------------------------------------------------------------------------------------------------

variable "enabled_standards" {
  description = <<DOC
  A list of standards/rulesets to enable

  See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription#argument-reference

  The possible values are:

    - standards/aws-foundational-security-best-practices/v/1.0.0
    - ruleset/cis-aws-foundations-benchmark/v/1.2.0
    - standards/pci-dss/v/3.2.1
  DOC
  type        = list
  default     = []
}

variable "create_sns_topic" {
  description = <<DOC
  Flag to indicate whether an SNS topic should be created for notifications

  If you want to send findings to a new SNS topic, set this to true and provide a valid configuration for subscribers
  DOC

  type    = bool
  default = false
}

variable "subscribers" {
  type = map(object({
    protocol               = string
    endpoint               = string
    endpoint_auto_confirms = bool
  }))
  description = <<DOC
  A map of subscription configurations for SNS topics
    
  For more information, see:
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#argument-reference
 
  protocol:         
    The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially 
    supported, see link) (email is an option but is unsupported in terraform, see link).
  endpoint:         
    The endpoint to send data to, the contents will vary with the protocol. (see link for more information)
  endpoint_auto_confirms:
    Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty. Default is 
    false
  DOC
  default     = {}
}

variable "imported_findings_notification_arn" {
  description = <<DOC
  The ARN for an SNS topic to send findings notifications to. This is only used if create_sns_topic is false.

  If you want to send findings to an existing SNS topic, set the value of this to the ARN of the existing topic and set 
  create_sns_topic to false.
  DOC
  default     = null
  type        = string
}

variable "cloudwatch_event_rule_pattern_detail_type" {
  description = <<DOC
  The detail-type pattern used to match events that will be sent to SNS. 

  For more information, see:
  https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/CloudWatchEventsandEventPatterns.html
  DOC
  type        = string
  default     = "Security Hub Findings - Imported"
}
