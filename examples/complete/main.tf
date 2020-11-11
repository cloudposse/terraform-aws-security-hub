provider "aws" {
  region = var.region
}

module "example" {
  source = "../.."

  context           = module.this.context
  enabled_standards = var.enabled_standards
  create_sns_topic  = var.create_sns_topic
}
