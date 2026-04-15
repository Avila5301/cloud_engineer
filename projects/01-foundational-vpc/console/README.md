# Project 01 — AWS Console Implementation

## Overview

A step-by-step walkthrough to build the foundational VPC entirely through the AWS Management Console. Estimated time: 30 minutes.

## Prerequisites

- AWS account with admin or power-user permissions
- Logged into the AWS Management Console
- An EC2 key pair created in your target region (EC2 → Key Pairs → Create)
- Your public IP address: visit https://checkip.amazonaws.com

---

## Step 1 — Create the VPC

1. Navigate to **VPC** → **Your VPCs** → **Create VPC**
2. Select **VPC only**
3. Configure:
   - **Name tag**: `cloud-engineer-01-vpc`
   - **IPv4 CIDR**: `10.0.0.0/16`
   - **Tenancy**: Default
4. Click **Create VPC**
5. Select the new VPC → **Actions** → **Edit VPC settings**
6. Enable both **DNS hostnames** and **DNS resolution** → **Save**

---

## Step 2 — Create Subnets

Navigate to **VPC** → **Subnets** → **Create subnet**

Select your VPC (`cloud-engineer-01-vpc`) then add all four subnets:

### Public Subnet 1
- **Subnet name**: `cloud-engineer-01-public-1`
- **Availability Zone**: `us-east-1a`
- **IPv4 CIDR**: `10.0.1.0/24`

### Public Subnet 2
- **Subnet name**: `cloud-engineer-01-public-2`
- **Availability Zone**: `us-east-1b`
- **IPv4 CIDR**: `10.0.2.0/24`

### Private Subnet 1
- **Subnet name**: `cloud-engineer-01-private-1`
- **Availability Zone**: `us-east-1a`
- **IPv4 CIDR**: `10.0.10.0/24`

### Private Subnet 2
- **Subnet name**: `cloud-engineer-01-private-2`
- **Availability Zone**: `us-east-1b`
- **IPv4 CIDR**: `10.0.20.0/24`

Click **Create subnet**

### Enable Auto-assign Public IP on Public Subnets

For each of the two public subnets:
1. Select the subnet → **Actions** → **Edit subnet settings**
2. Check **Enable auto-assign public IPv4 address**
3. **Save**

---

## Step 3 — Create and Attach an Internet Gateway

1. Navigate to **VPC** → **Internet gateways** → **Create internet gateway**
2. **Name tag**: `cloud-engineer-01-igw`
3. Click **Create internet gateway**
4. On the confirmation screen → **Actions** → **Attach to VPC**
5. Select `cloud-engineer-01-vpc` → **Attach internet gateway**

---

## Step 4 — Create the NAT Gateway

1. Navigate to **VPC** → **NAT gateways** → **Create NAT gateway**
2. Configure:
   - **Name**: `cloud-engineer-01-nat`
   - **Subnet**: `cloud-engineer-01-public-1`
   - **Connectivity type**: Public
3. Click **Allocate Elastic IP** (creates a new EIP automatically)
4. Click **Create NAT gateway**

> The NAT Gateway takes about 1 minute to become Available. Wait before proceeding.

---

## Step 5 — Create Route Tables

### Public Route Table

1. Navigate to **VPC** → **Route tables** → **Create route table**
2. Configure:
   - **Name**: `cloud-engineer-01-public-rt`
   - **VPC**: `cloud-engineer-01-vpc`
3. Click **Create route table**
4. Select the new route table → **Routes** tab → **Edit routes**
5. **Add route**:
   - **Destination**: `0.0.0.0/0`
   - **Target**: Internet Gateway → `cloud-engineer-01-igw`
6. **Save changes**
7. **Subnet associations** tab → **Edit subnet associations**
8. Check both public subnets → **Save associations**

### Private Route Table

1. **Create route table** again:
   - **Name**: `cloud-engineer-01-private-rt`
   - **VPC**: `cloud-engineer-01-vpc`
2. **Routes** tab → **Edit routes** → **Add route**:
   - **Destination**: `0.0.0.0/0`
   - **Target**: NAT Gateway → `cloud-engineer-01-nat`
3. **Save changes**
4. **Subnet associations** tab → **Edit subnet associations**
5. Check both private subnets → **Save associations**

---

## Step 6 — Create Security Groups

### Bastion Security Group

1. Navigate to **VPC** → **Security groups** → **Create security group**
2. Configure:
   - **Security group name**: `cloud-engineer-01-bastion-sg`
   - **Description**: `SSH access to bastion from admin IP only`
   - **VPC**: `cloud-engineer-01-vpc`
3. **Inbound rules** → **Add rule**:
   - **Type**: SSH
   - **Source**: Custom → `YOUR.IP.ADDRESS/32`
4. **Outbound rules**: leave default (all traffic allowed)
5. Click **Create security group**

### Private Instance Security Group

1. **Create security group**:
   - **Name**: `cloud-engineer-01-private-sg`
   - **Description**: `SSH access from bastion only`
   - **VPC**: `cloud-engineer-01-vpc`
2. **Inbound rules** → **Add rule**:
   - **Type**: SSH
   - **Source**: Custom → select `cloud-engineer-01-bastion-sg`
3. Click **Create security group**

---

## Step 7 — Launch the Bastion Host

1. Navigate to **EC2** → **Instances** → **Launch instances**
2. Configure:
   - **Name**: `cloud-engineer-01-bastion`
   - **AMI**: Amazon Linux 2 (search and select the latest)
   - **Instance type**: `t3.micro`
   - **Key pair**: select your existing key pair
3. **Network settings** → **Edit**:
   - **VPC**: `cloud-engineer-01-vpc`
   - **Subnet**: `cloud-engineer-01-public-1`
   - **Auto-assign public IP**: Enable
   - **Security group**: Select existing → `cloud-engineer-01-bastion-sg`
4. Click **Launch instance**

---

## Step 8 — Verify

Wait for the bastion to reach the **Running** state (1-2 minutes).

Get the public IP from the EC2 console → **Instances** → select bastion → **Public IPv4 address**.

SSH to the bastion:
```bash
ssh -i ~/.ssh/your-key-pair.pem ec2-user@<PUBLIC_IP>
```

From inside the bastion, test outbound internet via the NAT Gateway:
```bash
curl https://checkip.amazonaws.com
```

The returned IP should be the NAT Gateway's public IP — not the bastion's IP.

---

## Teardown (in reverse order)

> Delete resources in this exact order to avoid dependency errors.

1. **EC2** → terminate `cloud-engineer-01-bastion`
2. **VPC** → **NAT gateways** → delete `cloud-engineer-01-nat` → wait for Deleted status
3. **VPC** → **Elastic IPs** → release the EIP that was used by the NAT Gateway
4. **VPC** → **Route tables** → delete `cloud-engineer-01-public-rt` and `cloud-engineer-01-private-rt`
5. **VPC** → **Security groups** → delete `cloud-engineer-01-private-sg`, then `cloud-engineer-01-bastion-sg`
6. **VPC** → **Subnets** → delete all four subnets
7. **VPC** → **Internet gateways** → detach from VPC, then delete `cloud-engineer-01-igw`
8. **VPC** → **Your VPCs** → delete `cloud-engineer-01-vpc`

---

## Common Mistakes

- **Forgetting to enable DNS hostnames on the VPC** — EC2 instances won't get public DNS names
- **Associating subnets with the wrong route table** — private subnets routed to the IGW become publicly reachable
- **Creating the NAT Gateway in a private subnet** — it must be in a public subnet with internet access
- **Releasing the Elastic IP before deleting the NAT Gateway** — causes an error; always delete the NAT GW first
