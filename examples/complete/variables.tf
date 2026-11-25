variable "region" {
  type        = string
  description = "AWS region"
}

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

variable "control_finding_generator" {
  type        = string
  description = "Consolidated control findings setting: SECURITY_CONTROL, STANDARD_CONTROL or null"
  default     = null
}
