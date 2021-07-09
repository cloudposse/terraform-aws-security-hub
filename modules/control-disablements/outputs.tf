output "controls" {
  description = "A list of controls to disable based on the the input variables"
  value=local.included_rules
}