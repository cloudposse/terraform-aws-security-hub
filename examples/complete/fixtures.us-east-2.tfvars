region      = "us-east-2"
namespace   = "eg"
environment = "ue2"
stage       = "test"

create_sns_topic  = true
enabled_standards = ["standards/aws-foundational-security-best-practices/v/1.0.0", "ruleset/cis-aws-foundations-benchmark/v/1.2.0"]
