#-----------------------------------------------------------------------------------------------------------------------
# Subscribe the Account to Security Hub
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_securityhub_account" "this" {
  count = local.enabled ? 1 : 0

  control_finding_generator = var.control_finding_generator
  enable_default_standards  = var.enable_default_standards
}

#-----------------------------------------------------------------------------------------------------------------------
# Optionally subscribe to Security Hub Standards
# https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-standards.html
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_securityhub_standards_subscription" "this" {
  for_each      = local.enabled ? local.enabled_standards_arns : []
  depends_on    = [aws_securityhub_account.this]
  standards_arn = each.key
}

#-----------------------------------------------------------------------------------------------------------------------
# Optionally setup finding aggregator
# https://docs.aws.amazon.com/securityhub/latest/userguide/finding-aggregation.html
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_securityhub_finding_aggregator" "this" {
  count = local.enabled && var.finding_aggregator_enabled ? 1 : 0

  linking_mode      = var.finding_aggregator_linking_mode
  specified_regions = var.finding_aggregator_linking_mode == "ALL_REGIONS" ? null : var.finding_aggregator_regions

  depends_on = [aws_securityhub_account.this]
}

#-----------------------------------------------------------------------------------------------------------------------
# Optionally delegate control to a security account
# https://docs.aws.amazon.com/securityhub/latest/userguide/designate-orgs-admin-account.html
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_securityhub_organization_admin_account" "this" {
  count = var.delegation_account_id != "" ? 1 : 0

  admin_account_id = var.delegation_account_id

  depends_on = [aws_securityhub_account.this]
}

#-----------------------------------------------------------------------------------------------------------------------
# Locals and Data References
#-----------------------------------------------------------------------------------------------------------------------
locals {
  enabled                            = module.this.enabled
  enable_notifications               = local.enabled && (var.create_sns_topic || var.imported_findings_notification_arn != null)
  create_sns_topic                   = local.enabled && var.create_sns_topic
  imported_findings_notification_arn = local.enable_notifications ? (var.imported_findings_notification_arn != null ? var.imported_findings_notification_arn : module.sns_topic[0].sns_topic.arn) : null
  enabled_standards_arns = toset([
    for standard in var.enabled_standards :
    format("arn:%s:securityhub:%s::%s", one(data.aws_partition.this[*].partition), length(regexall("ruleset", standard)) == 0 ? one(data.aws_region.this[*].name) : "", standard) if local.enabled
  ])
}

data "aws_caller_identity" "this" {
  count = local.enabled ? 1 : 0
}

data "aws_partition" "this" {
  count = local.enabled ? 1 : 0
}

data "aws_region" "this" {
  count = local.enabled ? 1 : 0
}
