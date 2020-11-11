<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 2 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| cloudwatch\_event\_rule\_pattern\_detail\_type | The detail-type pattern used to match events that will be sent to SNS. <br><br>  For more information, see:<br>  https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/CloudWatchEventsandEventPatterns.html | `string` | `"Security Hub Findings - Imported"` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| create\_sns\_topic | Flag to indicate whether an SNS topic should be created for notifications<br><br>  If you want to send findings to a new SNS topic, set this to true and provide a valid configuration for subscribers | `bool` | `false` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| enabled\_standards | A list of standards/rulesets to enable<br><br>  See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription#argument-reference<br><br>  The possible values are:<br><br>    - standards/aws-foundational-security-best-practices/v/1.0.0<br>    - ruleset/cis-aws-foundations-benchmark/v/1.2.0<br>    - standards/pci-dss/v/3.2.1 | `list` | `[]` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| imported\_findings\_notification\_arn | The ARN for an SNS topic to send findings notifications to. This is only used if create\_sns\_topic is false.<br><br>  If you want to send findings to an existing SNS topic, set the value of this to the ARN of the existing topic and set <br>  create\_sns\_topic to false. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| subscribers | A map of subscription configurations for SNS topics<br><br>  For more information, see:<br>  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#argument-reference<br> <br>  protocol:       <br>    The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially <br>    supported, see link) (email is an option but is unsupported in terraform, see link).<br>  endpoint:       <br>    The endpoint to send data to, the contents will vary with the protocol. (see link for more information)<br>  endpoint\_auto\_confirms:<br>    Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty. Default is <br>    false | <pre>map(object({<br>    protocol               = string<br>    endpoint               = string<br>    endpoint_auto_confirms = bool<br>  }))</pre> | `{}` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| enabled\_subscriptions | --------------------------------------------------------------------------------------------------------------------- MODULE OUTPUTS --------------------------------------------------------------------------------------------------------------------- |
| sns\_topic | The SNS topic that was created |
| sns\_topic\_subscriptions | The SNS topic that was created |

<!-- markdownlint-restore -->
