output "enabled_subscriptions" {
  description = "Enabled subscriptions"
  value       = module.example.enabled_subscriptions
}

output "sns_topic" {
  description = "The SNS topic that was created"
  value = module.example.sns_topic
}
