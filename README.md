# New-micro-infra

This repo contains Terraform modules and environment configurations for a microservice blueprint on Azure. It includes CI/CD workflows (GitHub Actions and Azure DevOps) with security scans and cost estimation.

Required secrets (set in GitHub repository secrets or Azure DevOps variable groups):

- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID` — for Terraform runs that apply resources.
- `INFRACOST_API_KEY` — for Infracost comments and breakdowns.
- `SONAR_TOKEN` — optional, for SonarQube scans.

Quick start (dev):

1. Populate `env/dev/terraform.tfvars` with your values (resource names, storage account for backend, etc.).
2. Create a storage account and container for Terraform backend or configure remote state.
3. Create a GitHub environment `prod-approval` and configure required reviewers for manual approval.
4. Open a PR — CI runs formatting, validation and security scans. Review and approve.

Pipelines:

- `.github/workflows/terraform-pr.yml` — PR checks: `terraform fmt`, `validate`, `tflint`, `tfsec`, `checkov`, `infracost` and optional SonarQube.
- `.github/workflows/terraform-apply.yml` — apply pipeline on push to main with environment approval.
- `azure-pipelines.yml` — Azure DevOps pipeline with stages: Validate, Plan, CostEstimate, ManualApproval, Apply.

Next recommended tasks:

- Replace placeholder values in `env/*/terraform.tfvars` with production-safe names.
- Harden modules: private endpoints, Key Vault access policies, RBAC roles, diagnostic settings.
- Add unit/integration tests (Terratest) as needed.

Bootstrap backend (create storage account/container for remote state):

1. Run the bootstrap environment to create a storage account and container used for Terraform remote state:

```bash
cd env/bootstrap
terraform init
terraform apply -auto-approve
```

2. Update the `backend` block in your environment `provider.tf` or `main.tf` to point to the created storage account and container.

Linting & scans:

- Use `make fmt`, `make validate`, `make tflint`, `make tfsec`, `make checkov`.

