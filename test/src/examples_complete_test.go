package test

import (
	"math/rand"
	"strconv"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	// We always include a random attribute so that parallel tests and AWS resources do not interfere with each
	// other
	randID := strconv.Itoa(rand.Intn(100000))
	attributes := []string{randID}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		Vars: map[string]interface{}{
			"attributes":        attributes,
			"create_sns_topic":  true,
			"enabled_standards": []string{"standards/aws-foundational-security-best-practices/v/1.0.0", "ruleset/cis-aws-foundations-benchmark/v/1.2.0"},
		},
	}
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Get terraform Outputs
	enabledStandards := terraform.OutputList(t, terraformOptions, "enabled_subscriptions")
	snsTopic := terraform.OutputMap(t, terraformOptions, "sns_topic")

	// Verify we're getting back the outputs we expect
	assert.Contains(t, enabledStandards, "arn:aws:securityhub:us-east-2:226010001608:subscription/cis-aws-foundations-benchmark/v/1.2.0")
	assert.Contains(t, enabledStandards, "arn:aws:securityhub:us-east-2:226010001608:subscription/aws-foundational-security-best-practices/v/1.0.0")
	assert.Contains(t, snsTopic, "id")
	assert.Greater(t, len(snsTopic["id"]), 0)
}
