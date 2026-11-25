provider "aws" {
  region = var.region
}

module "example" {
  source = "../.."

  enabled_standards         = var.enabled_standards
  create_sns_topic          = var.create_sns_topic
  control_finding_generator = var.control_finding_generator

  context = module.this.context
}
