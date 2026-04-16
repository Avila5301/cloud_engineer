# Project 01 — CloudFormation Implementation

## Learning Flow

```
Stage 1: Exercise    → Complete a partial CloudFormation template
Stage 2: Troubleshoot → Find and fix 5 errors in a broken template
Stage 3: Solution    → Deploy the working stack
```

---

## Stage 1 — Exercise: Build It

**Folder:** `exercise/`

You are given a partial CloudFormation template with the Parameters, Metadata, and Outputs sections complete. Your job is to fill in the Resources section by writing the CloudFormation resource blocks for each component of the VPC.

[Go to Exercise →](./exercise/README.md)

---

## Stage 2 — Troubleshoot: Fix It

**Folder:** `troubleshoot/`

A complete-looking CloudFormation template with **5 intentional errors**. Some will cause the stack to fail during creation. Others will allow the stack to create successfully but leave you with a broken network.

Find and fix all 5 by reading the template — not by deploying it.

[Go to Troubleshoot →](./troubleshoot/README.md)

---

## Stage 3 — Solution: Deploy It

**Folder:** `solution/`

The complete, working CloudFormation template. Deploy it once you have completed the exercise and troubleshoot stages.

```bash
aws cloudformation deploy \
  --template-file solution/vpc-stack.yaml \
  --stack-name cloud-engineer-01-vpc \
  --parameter-overrides \
      AdminIpCidr="YOUR.IP/32" \
      KeyPairName="your-key-pair-name" \
  --region us-east-1
```

Teardown:
```bash
aws cloudformation delete-stack --stack-name cloud-engineer-01-vpc --region us-east-1
aws cloudformation wait stack-delete-complete --stack-name cloud-engineer-01-vpc --region us-east-1
```

[Go to Solution →](./solution/)
