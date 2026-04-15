# Project XX — Terraform Implementation

## Overview

<!-- Brief description of what this Terraform configuration provisions -->

## Prerequisites

- Terraform >= 1.5 installed
- AWS CLI configured (`aws configure`)
- An S3 bucket for remote state (optional but recommended)

## Files

| File | Purpose |
|---|---|
| `main.tf` | Core resource definitions |
| `variables.tf` | Input variable declarations |
| `outputs.tf` | Output values |
| `terraform.tfvars.example` | Example variable values — copy to `terraform.tfvars` |

## Setup

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

## Deploy

```bash
terraform init
terraform plan
terraform apply
```

## Verify

<!-- Commands or Console checks to confirm resources are working -->

## Teardown

```bash
terraform destroy
```

> Confirm the destroy plan carefully before approving.
