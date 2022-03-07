#-----------------------------------------------------------------------------------------------------------------------
# Subscribe the Acccount to Security Hub
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_securityhub_account" "this" {
  count = module.this.enabled ? 1 : 0
}

#-----------------------------------------------------------------------------------------------------------------------
# Optionally subscribe to Security Hub Standards
# https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-standards.html
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_securityhub_standards_subscription" "this" {
  for_each      = local.enabled_standards_arns
  depends_on    = [aws_securityhub_account.this]
  standards_arn = each.key
}

resource "aws_securityhub_organization_configuration" "this" {
  count       = var.activate_organisation_auto_enable ? 1 : 0
  auto_enable = var.activate_organisation_auto_enable
}

#-----------------------------------------------------------------------------------------------------------------------
# Locals and Data References
#-----------------------------------------------------------------------------------------------------------------------
locals {
  enable_notifications               = module.this.enabled && (var.create_sns_topic || var.imported_findings_notification_arn != null)
  create_sns_topic                   = module.this.enabled && var.create_sns_topic
  imported_findings_notification_arn = local.enable_notifications ? (var.imported_findings_notification_arn != null ? var.imported_findings_notification_arn : module.sns_topic[0].sns_topic.arn) : null
  enabled_standards_arns = toset([
    for standard in var.enabled_standards :
    format("arn:%s:securityhub:%s::%s", data.aws_partition.this.partition, length(regexall("ruleset", standard)) == 0 ? data.aws_region.this.name : "", standard)
  ])
}

data "aws_caller_identity" "this" {}
data "aws_partition" "this" {}
data "aws_region" "this" {}
