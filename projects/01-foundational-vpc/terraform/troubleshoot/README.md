# Stage 2 — Troubleshoot: Find and Fix the Errors

## The Scenario

You are reviewing a pull request. The author says it works on their machine. You are not convinced. Read `main.tf` carefully — there are **5 errors** embedded in it.

## Your Task

Find and fix all 5 errors in `main.tf` before the PR merges. Do not run `terraform apply` to discover them — read the code.

## Error Categories

1. **Security error** — Public subnets will not auto-assign public IPs, breaking bastion access
2. **Logical error** — NAT Gateway is placed in a private subnet instead of a public one
3. **Logical error** — Private route table routes traffic through the Internet Gateway instead of NAT
4. **Dependency error** — Missing `depends_on` that causes a race condition during apply
5. **Placement error** — Bastion EC2 instance is launched in a private subnet instead of public

## How to Verify Your Fixes

After fixing all 5 errors, run:

```bash
terraform init
terraform validate
terraform plan
```

The plan should show 17 resources and no errors. Then compare your fixes against `solution/main.tf`.

## Why These Errors Matter in Production

- No auto-assign public IP → bastion gets no public address → you cannot SSH in
- NAT Gateway in a private subnet → NAT has no internet access → private instances cannot reach the internet
- Private route to IGW → private instances become directly internet-reachable → massive security risk
- Missing `depends_on` on EIP → apply may fail intermittently depending on provisioning order
- Bastion in private subnet → no public IP → completely unreachable
