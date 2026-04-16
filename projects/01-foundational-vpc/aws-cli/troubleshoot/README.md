# Stage 2 — Troubleshoot: Find and Fix the Errors

## The Scenario

A colleague handed you `deploy-broken.sh` and said "I wrote this last night but it's not working right — can you take a look?" They did not tell you what is wrong.

## Your Task

Read `deploy-broken.sh` carefully. There are **5 errors** in the script. Some will cause the script to fail immediately. Others will allow the script to run to completion but leave you with a broken or insecure network.

Find all 5. Fix them in the file. Do not run the script to find the errors — read it.

## Error Categories

To help narrow your search (but not give away locations), here is the category of each error:

1. **Security error** — An inbound rule is more permissive than it should be
2. **Logical error** — A resource is created in the wrong subnet
3. **Logical error** — The public and private route table destinations are swapped
4. **Configuration error** — A subnet CIDR block conflicts with another subnet
5. **Operational error** — A missing wait step that will cause a downstream command to fail

## How to Verify Your Fixes

After identifying and fixing all 5 errors, compare your corrected version against `solution/deploy.sh` line by line. If your fixes match, you understand the script well enough to deploy it.

## Why This Matters

Each of these errors represents a real mistake engineers make:

- A security group open to the world instead of a specific IP has caused actual data breaches
- NAT Gateway in the wrong subnet is the #1 VPC misconfiguration seen in the field
- Swapped routes mean private instances have direct internet access and public instances can't reach the internet
- Overlapping CIDRs silently break routing and are painful to diagnose
- Missing waits cause intermittent failures that are hard to reproduce

## When You Are Done

Use `solution/deploy.sh` to perform the actual deployment. Run `solution/teardown.sh` when done.
