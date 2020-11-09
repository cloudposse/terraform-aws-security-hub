output "enabled_subscriptions" {
  description = "A list of subscriptions that have been enabled"
  value = [
    for standard in aws_securityhub_standards_subscription.this :
    standard.id
  ]
}

output "sns_topic" {
  description = "The SNS topic that was created"
  value       = local.create_sns_topic ? module.sns_topic[0].sns_topic : null
}

output "sns_topic_subscriptions" {
  description = "The SNS topic that was created"
  value       = local.create_sns_topic ? module.sns_topic[0].aws_sns_topic_subscriptions : null
}
