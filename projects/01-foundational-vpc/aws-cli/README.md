# Project 01 — AWS CLI Implementation

## Overview

Two scripts are provided:
- `deploy.sh` — provisions the entire VPC stack
- `teardown.sh` — destroys all resources in the correct order

All resource IDs are written to `resource-ids.env` during deployment so teardown can find them automatically.

## Prerequisites

- AWS CLI v2 installed and configured (`aws configure`)
- An EC2 key pair already created in your target region
- `jq` installed (used to parse CLI JSON output)

Install jq:
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq
```

## Setup

Edit the variables at the top of `deploy.sh`:

```bash
AWS_REGION="us-east-1"
AZ1="us-east-1a"
AZ2="us-east-1b"
KEY_PAIR_NAME="your-key-pair-name"    # Must already exist in your region
YOUR_IP="$(curl -s https://checkip.amazonaws.com)/32"  # Auto-detects your IP
```

## Deploy

```bash
chmod +x deploy.sh teardown.sh
./deploy.sh
```

The script will output progress as it creates each resource and save all IDs to `resource-ids.env`.

## Verify

After deployment, the script will output the Bastion Host public IP. Connect to it:

```bash
ssh -i ~/.ssh/your-key.pem ec2-user@<BASTION_PUBLIC_IP>
```

From inside the bastion:
```bash
# Confirm outbound internet access from public subnet
curl https://checkip.amazonaws.com

# The returned IP should match your bastion's public IP
```

## Teardown

```bash
./teardown.sh
```

The teardown script reads `resource-ids.env` and deletes everything in the correct order (NAT Gateway first, then wait for deletion, then release the Elastic IP, etc.).

> NAT Gateway deletion takes ~1 minute. The script waits automatically.
