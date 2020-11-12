output "enabled_subscriptions" {
  description = "Enabled subscriptions"
  value       = module.example.enabled_subscriptions
}

output "sns_topic" {
  value = module.example.sns_topic
}
