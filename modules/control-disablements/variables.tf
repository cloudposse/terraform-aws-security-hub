variable "global_resource_collector_region" {
  description = "The region that collects AWS Config data for global resources such as IAM"
  type        = string
}

variable "central_logging_account" {
  description = "The id of the account that is the centralized cloudtrail logging account."
  type        = string
}