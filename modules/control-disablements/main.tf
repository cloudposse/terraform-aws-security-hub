#-----------------------------------------------------------------------------------------------------------------------
# DATA SOURCES AND LOCALS
#-----------------------------------------------------------------------------------------------------------------------
data "aws_partition" "this" {}
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

locals {
  is_global_resource_region     = data.aws_region.this.name == var.global_resource_collector_region
  is_central_cloudtrail_account = data.aws_caller_identity.this.account_id == var.central_logging_account

  all_global_region_controls = [
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/aws-foundational-security-best-practices/v/1.0.0/Config.1",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/aws-foundational-security-best-practices/v/1.0.0/IAM.1",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/aws-foundational-security-best-practices/v/1.0.0/IAM.2",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/aws-foundational-security-best-practices/v/1.0.0/IAM.3",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/aws-foundational-security-best-practices/v/1.0.0/IAM.4",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/aws-foundational-security-best-practices/v/1.0.0/IAM.5",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/aws-foundational-security-best-practices/v/1.0.0/IAM.6",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/aws-foundational-security-best-practices/v/1.0.0/IAM.7",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.2",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.3",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.4",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.5",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.6",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.7",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.8",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.9",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.10",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.11",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.12",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.13",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.14",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.16",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.20",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.22",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/2.5",
  ]
  included_global_region_controls = [for c in local.all_global_region_controls : c if ! local.is_global_resource_region]

  all_cloudtrail_controls = [
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/1.1",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/2.7",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.1",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.2",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.3",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.4",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.5",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.6",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.7",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.8",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.9",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.10",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.11",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.12",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.13",
    "arn:${data.aws_partition.this.id}:securityhub:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/3.14",
  ]
  included_cloudtrail_controls = [for r in local.all_cloudtrail_controls : r if ! local.is_central_cloudtrail_account]

  included_controls = concat(local.included_global_region_controls, local.included_cloudtrail_controls)
}
