# Project XX — AWS CLI Implementation

## Overview

<!-- Brief description of what this script does -->

## Prerequisites

- AWS CLI v2 installed and configured (`aws configure`)
- IAM permissions required: <!-- list the minimum IAM actions needed -->
- Environment variables set (see below)

## Setup

```bash
# Set your variables
export AWS_REGION="us-east-1"
export PROJECT_NAME="my-project"
```

## Deploy

```bash
chmod +x deploy.sh
./deploy.sh
```

## Verify

<!-- Commands to confirm everything is working -->

```bash
# Example verification
aws <service> describe-<resource> --region $AWS_REGION
```

## Teardown

```bash
chmod +x teardown.sh
./teardown.sh
```

> Always run teardown when done to avoid ongoing charges.
