output "enabled_subscriptions" {
  description = "Enabled subscriptions"
  value       = module.example.enabled_subscriptions
}

output "sns_topic" {
  description = "SNS Topic"
  value       = module.example.sns_topic
}
