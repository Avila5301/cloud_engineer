# Project 01 — CloudFormation Implementation

## Overview

A single CloudFormation stack (`vpc-stack.yaml`) that provisions the entire VPC network. Stack outputs export key resource IDs so future stacks can reference them using `Fn::ImportValue`.

## Prerequisites

- AWS CLI configured (`aws configure`)
- An EC2 key pair already created in your target region
- IAM permissions: `cloudformation:*`, `ec2:*`

## Setup

Find your public IP:
```bash
curl https://checkip.amazonaws.com
```

## Deploy

```bash
aws cloudformation deploy \
  --template-file vpc-stack.yaml \
  --stack-name cloud-engineer-01-vpc \
  --parameter-overrides \
      AdminIpCidr="YOUR.PUBLIC.IP.HERE/32" \
      KeyPairName="your-key-pair-name" \
  --region us-east-1
```

The stack takes approximately 2-3 minutes to complete (mostly waiting for the NAT Gateway).

## Check Stack Status

```bash
aws cloudformation describe-stacks \
  --stack-name cloud-engineer-01-vpc \
  --region us-east-1 \
  --query 'Stacks[0].{Status:StackStatus,Outputs:Outputs}'
```

## Get the Bastion IP and SSH Command

```bash
aws cloudformation describe-stacks \
  --stack-name cloud-engineer-01-vpc \
  --region us-east-1 \
  --query 'Stacks[0].Outputs[?OutputKey==`SshCommand`].OutputValue' \
  --output text
```

## Verify

SSH to the bastion using the command from the output above, then run:
```bash
curl https://checkip.amazonaws.com
# Should return the NAT Gateway public IP — not the bastion's IP
```

## Teardown

```bash
aws cloudformation delete-stack \
  --stack-name cloud-engineer-01-vpc \
  --region us-east-1

# Wait for complete deletion
aws cloudformation wait stack-delete-complete \
  --stack-name cloud-engineer-01-vpc \
  --region us-east-1

echo "Stack deleted."
```

> CloudFormation deletes resources in the correct reverse-dependency order automatically.

## Stack Exports

The stack exports these values for use in future stacks via `Fn::ImportValue`:

| Export Name | Description |
|---|---|
| `cloud-engineer-01-VpcId` | VPC ID |
| `cloud-engineer-01-PublicSubnet1Id` | Public Subnet 1 ID |
| `cloud-engineer-01-PublicSubnet2Id` | Public Subnet 2 ID |
| `cloud-engineer-01-PrivateSubnet1Id` | Private Subnet 1 ID |
| `cloud-engineer-01-PrivateSubnet2Id` | Private Subnet 2 ID |
| `cloud-engineer-01-BastionSgId` | Bastion Security Group ID |
| `cloud-engineer-01-PrivateSgId` | Private Instance Security Group ID |

Future projects that build on top of this VPC can reference these exports instead of hardcoding IDs.
