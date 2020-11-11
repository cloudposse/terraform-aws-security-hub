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

#-----------------------------------------------------------------------------------------------------------------------
# Optionally configure Event Bridge Rules and SNS subscriptions 
# https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cwe-integration-types.html
#-----------------------------------------------------------------------------------------------------------------------
module "sns_topic" {
  source = "git::https://github.com/cloudposse/terraform-aws-sns-topic.git?ref=tags/0.9.0"
  count  = local.create_sns_topic ? 1 : 0

  context         = module.this.context
  subscribers     = {}
  sqs_dlq_enabled = false
}

resource "aws_cloudwatch_event_rule" "imported_findings" {
  count       = local.enable_notifications == true ? 1 : 0
  name        = "${module.this.id}-imported-findings"
  description = "SecurityHubEvent - Imported Findings"
  tags        = module.this.tags

  event_pattern = jsonencode(
    {
      "source" : [
        "aws.securityhub"
      ],
      "detail-type" : [
        "Security Hub Findings - Imported"
      ]
    }
  )
}

resource "aws_cloudwatch_event_target" "imported_findings" {
  count     = local.enable_notifications == true ? 1 : 0
  rule      = aws_cloudwatch_event_rule.imported_findings[0].name
  target_id = "SendToSNS"
  arn       = local.imported_findings_notification_arn
}

#-----------------------------------------------------------------------------------------------------------------------
# Locals and Data References
#-----------------------------------------------------------------------------------------------------------------------
locals {
  enable_notifications               = module.this.enabled && (var.create_sns_topic || var.imported_findings_notification_arn != null)
  create_sns_topic                   = module.this.enabled && var.create_sns_topic
  imported_findings_notification_arn = local.enable_notifications ? var.imported_findings_notification_arn != null ? var.imported_findings_notification_arn : module.sns_topic[0].sns_topic.arn : null
  enabled_standards_arns = toset([
    for standard in var.enabled_standards :
    format("arn:%s:securityhub:%s::%s", data.aws_partition.this.partition, length(regexall("ruleset", standard)) == 0 ? data.aws_region.this.name : "", standard)
  ])
}

data "aws_partition" "this" {}
data "aws_region" "this" {}
