package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformProdPlan(t *testing.T) {
    t.Parallel()

    opts := &terraform.Options{
        TerraformDir: "../env/prod",
    }

    // Run init and plan (no apply) to validate the configuration
    terraform.InitE(t, opts)
    _, err := terraform.PlanE(t, opts)
    if err != nil {
        t.Fatalf("terraform plan failed: %v", err)
    }
}
