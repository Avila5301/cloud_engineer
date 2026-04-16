# Stage 1 — Exercise: Build the Deploy Script

## Goal

Complete `deploy-starter.sh` by filling in all `# TODO` sections. When finished, you should have a script that can provision the full VPC stack from scratch.

## Rules

- Do not copy from the solution folder
- Use the [AWS CLI v2 documentation](https://awscli.amazonaws.com/v2/documentation/api/latest/index.html) when you get stuck
- It is okay to look up command syntax — the goal is understanding, not memorization

## What You Are Building

Review the architecture in the [Problem Statement](../PROBLEM_STATEMENT.md) before you start. You need to understand the end state before you can write the commands to get there.

## Sections to Complete

Work through `deploy-starter.sh` top to bottom. Each `# TODO` block tells you what to accomplish. Key sections left for you:

| Section | What to fill in |
|---|---|
| Variables | CIDR blocks, AZ names, instance type |
| VPC creation | The `aws ec2 create-vpc` command and DNS settings |
| Subnet creation | All four `aws ec2 create-subnet` commands with correct CIDRs and AZs |
| Internet Gateway | Create and attach commands |
| NAT Gateway | EIP allocation and NAT creation — pay attention to which subnet it goes in |
| Route Tables | Create, add routes, and associate with the correct subnets |
| Security Groups | Create with correct inbound rules — the bastion SG is especially important |
| EC2 Launch | The `aws ec2 run-instances` command |

## Hints

- The `--query` flag with `--output text` is the standard way to capture a resource ID from CLI output
- `aws ec2 wait` commands exist for resources that take time to become ready — use them
- NAT Gateways must be created in a **public** subnet, not a private one
- Route tables control where traffic goes — double-check which table gets the IGW route vs the NAT route
- Security group inbound rules: the bastion should only allow SSH from **your IP**, not `0.0.0.0/0`

## When You Are Done

Run your completed script in a test environment and verify against the success criteria in the Problem Statement. Then move on to Stage 2.

> If your script runs successfully, do not tear down yet — you can use the same environment for Stage 2 verification.
