# Stage 2 — Troubleshoot: Find and Fix the Errors

## The Scenario

You are reviewing `vpc-stack-broken.yaml` before it goes to production. The author has deployed it to a dev account and says "it works." You review it and find 5 errors — some of which would have silently broken the network in production.

## Your Task

Read `vpc-stack-broken.yaml` carefully. Find and fix all **5 errors**.

Do not deploy the template to find the errors. Read it.

## Error Categories

1. **AZ error** — Both public subnets are in the same Availability Zone
2. **Placement error** — NAT Gateway is placed in a private subnet
3. **Dependency error** — Missing `DependsOn` that causes a race condition during stack creation
4. **Route error** — Private route table uses `GatewayId` (IGW) instead of `NatGatewayId`
5. **Configuration error** — Public subnets do not auto-assign public IPs

## How to Verify Your Fixes

After fixing all 5 errors, validate with:

```bash
cfn-lint vpc-stack-broken.yaml
aws cloudformation validate-template --template-body file://vpc-stack-broken.yaml
```

Then compare against `solution/vpc-stack.yaml`.

## Why These Errors Are Dangerous

- **Same AZ for both public subnets** — Looks fine in dev, but if that AZ goes down, both public subnets fail together. Defeats the purpose of multi-AZ.
- **NAT Gateway in private subnet** — NAT has no internet access. Private instances appear healthy but cannot reach the internet. Debugging this is confusing because the NAT Gateway itself shows as Available.
- **Missing DependsOn on EIP** — Stack creation may fail with "The allocation ID does not exist" because the IGW isn't fully attached yet when the EIP is allocated.
- **Private route to IGW** — Private instances become directly routable from the internet. Any security group gap becomes a direct exposure.
- **No auto-assign public IP** — Bastion host launches with no public IP. You cannot SSH in. The instance runs fine — it just has no way to be reached.
