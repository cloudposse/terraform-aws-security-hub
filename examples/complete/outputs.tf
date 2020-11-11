# ---------------------------------------------------------------------------------------------------------------------
# MODULE OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------
output "enabled_subscriptions" {
  description = "ID of the created example"
  value       = module.example.enabled_subscriptions
}

output "sns_topic" {
  value = module.example.sns_topic
}
