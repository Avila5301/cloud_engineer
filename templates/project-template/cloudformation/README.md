# Project XX — CloudFormation Implementation

## Overview

<!-- Brief description of what this CloudFormation stack provisions -->

## Prerequisites

- AWS CLI configured (`aws configure`)
- IAM permissions: `cloudformation:*`, plus permissions for resources being created

## Files

| File | Purpose |
|---|---|
| `stack.yaml` | CloudFormation template |
| `parameters.json.example` | Example parameter file — copy to `parameters.json` |

## Setup

```bash
cp parameters.json.example parameters.json
# Edit parameters.json with your values
```

## Deploy

```bash
aws cloudformation deploy \
  --template-file stack.yaml \
  --stack-name my-stack-name \
  --parameter-overrides file://parameters.json \
  --capabilities CAPABILITY_IAM \
  --region us-east-1
```

## Check Stack Status

```bash
aws cloudformation describe-stacks \
  --stack-name my-stack-name \
  --region us-east-1
```

## Teardown

```bash
aws cloudformation delete-stack \
  --stack-name my-stack-name \
  --region us-east-1

# Wait for deletion
aws cloudformation wait stack-delete-complete \
  --stack-name my-stack-name \
  --region us-east-1
```

> Always delete stacks when done to avoid ongoing charges.
