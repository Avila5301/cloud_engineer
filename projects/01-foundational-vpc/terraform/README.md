# Project 01 — Terraform Implementation

## Overview

This Terraform configuration provisions the complete foundational VPC network: VPC, subnets, Internet Gateway, NAT Gateway, route tables, security groups, and a bastion host.

## Prerequisites

- Terraform >= 1.5 installed
- AWS CLI configured (`aws configure`)
- An EC2 key pair already created in your target region

## Files

| File | Purpose |
|---|---|
| `main.tf` | All resource definitions |
| `variables.tf` | Input variable declarations with defaults |
| `outputs.tf` | Useful output values printed after apply |
| `terraform.tfvars.example` | Example values — copy to `terraform.tfvars` |

## Setup

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:
- Set `admin_ip_cidr` to your public IP: `curl https://checkip.amazonaws.com` then append `/32`
- Set `key_pair_name` to your existing EC2 key pair name

## Deploy

```bash
terraform init
terraform plan    # Review what will be created
terraform apply   # Type 'yes' to confirm
```

After apply, Terraform outputs your bastion's public IP and SSH command:

```
bastion_ssh_command = "ssh -i ~/.ssh/your-key.pem ec2-user@1.2.3.4"
```

## Verify

SSH to the bastion:
```bash
ssh -i ~/.ssh/your-key-pair.pem ec2-user@<bastion_public_ip>
```

From the bastion, confirm outbound internet via NAT:
```bash
curl https://checkip.amazonaws.com
# Should return the NAT Gateway's public IP, not the bastion's IP
```

## Teardown

```bash
terraform destroy
```

Review the destroy plan carefully. Type `yes` to confirm.

> The NAT Gateway is the main cost driver. Destroy promptly when done.

## Notes

- `terraform.tfvars` is excluded from git via `.gitignore` — never commit real IPs or key names
- The configuration uses `count` on subnets so it's easy to add a third AZ later
- All resources share `common_tags` for easy cost allocation filtering in AWS Cost Explorer
