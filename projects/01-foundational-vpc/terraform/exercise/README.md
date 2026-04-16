# Stage 1 — Exercise: Complete the Terraform Configuration

## Goal

Complete `main.tf` by filling in every `# TODO` resource block. The variables and outputs files are already complete and provided for reference — you do not need to modify them.

## Rules

- Do not look at the solution folder
- Use the [Terraform AWS Provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) when you get stuck
- Run `terraform validate` and `terraform plan` to check your work before applying

## Files Provided

| File | Status |
|---|---|
| `main.tf` | **Your work** — fill in all TODO sections |
| `variables.tf` | Complete — read it to understand what variables are available |
| `outputs.tf` | Complete — read it to understand what your resources should be named |

## What to Build

Fill in the following resource blocks in `main.tf`:

| Resource | Terraform Type | Notes |
|---|---|---|
| VPC | `aws_vpc` | Enable DNS hostnames and support |
| Public subnets (×2) | `aws_subnet` | Use `count`, enable auto-assign public IP |
| Private subnets (×2) | `aws_subnet` | Use `count`, no public IP |
| Internet Gateway | `aws_internet_gateway` | |
| Elastic IP for NAT | `aws_eip` | Domain must be `vpc` |
| NAT Gateway | `aws_nat_gateway` | Goes in public subnet, depends on IGW |
| Public route table | `aws_route_table` | Route 0.0.0.0/0 → IGW |
| Public RT associations (×2) | `aws_route_table_association` | |
| Private route table | `aws_route_table` | Route 0.0.0.0/0 → NAT Gateway |
| Private RT associations (×2) | `aws_route_table_association` | |
| Bastion security group | `aws_security_group` | SSH from `var.admin_ip_cidr` only |
| Private security group | `aws_security_group` | SSH from bastion SG only |
| Bastion EC2 instance | `aws_instance` | Public subnet, bastion SG |

## Hints

- Use `count = length(var.public_subnet_cidrs)` to create multiple subnets without repeating resource blocks
- Reference a counted resource with `aws_subnet.public[count.index].id`
- The NAT Gateway needs `depends_on = [aws_internet_gateway.main]` — think about why
- Security group source for SSH from another SG uses `security_groups`, not `cidr_blocks`
- `var.common_tags` is available for tagging — use `merge()` to add a `Name` tag per resource

## Checking Your Work

```bash
terraform init
terraform validate    # Checks syntax and references
terraform plan        # Review the plan before applying
```

The plan should show approximately 17 resources to be created.
