# Project 01 — AWS Console Implementation

## Learning Flow

The console method does not involve scripts or templates, so the exercise and troubleshoot stages work differently here.

```
Stage 1: Exercise    → Build the VPC from a checklist with intentional gaps
Stage 2: Troubleshoot → Audit a described misconfigured environment and list the fixes
Stage 3: Solution    → Full step-by-step walkthrough for actual deployment
```

---

## Stage 1 — Exercise: Build It From an Incomplete Checklist

**Goal:** Complete the VPC build using only the checklist below. Some steps have been intentionally left vague or incomplete. Fill in the gaps using the AWS Console and your knowledge of VPC architecture.

**Rules:** Do not look at the Solution section until you have completed a genuine attempt.

### Checklist

#### VPC
- [ ] Create a VPC with CIDR `10.0.0.0/16`
- [ ] Enable the two settings that allow EC2 instances to get DNS names *(what are they?)*

#### Subnets
- [ ] Create 4 subnets — 2 public, 2 private, spread across 2 AZs
- [ ] Use the CIDR scheme from the Problem Statement
- [ ] Configure public subnets so instances automatically get a public IP *(which setting controls this?)*

#### Gateways
- [ ] Create and attach an Internet Gateway
- [ ] Create a NAT Gateway *(in which subnet does it belong? why?)*
- [ ] The NAT Gateway requires an additional resource before it can be created *(what is it?)*

#### Route Tables
- [ ] Create a public route table — traffic to `0.0.0.0/0` should go where?
- [ ] Associate the public route table with the correct subnets
- [ ] Create a private route table — traffic to `0.0.0.0/0` should go where?
- [ ] Associate the private route table with the correct subnets

#### Security Groups
- [ ] Create a bastion security group — allow SSH inbound from *(what source?)*
- [ ] Create a private instance security group — allow SSH inbound from *(what source — an IP or another security group?)*

#### EC2
- [ ] Launch a bastion host in the correct subnet with the correct security group

#### Verify
- [ ] SSH to the bastion and confirm it's reachable
- [ ] From the bastion, run `curl https://checkip.amazonaws.com` — what IP should be returned?

---

## Stage 2 — Troubleshoot: Audit a Broken Environment

**Goal:** Read the environment description below and list every configuration mistake. Do not log into the console to check — identify the issues from the description alone.

### Broken Environment Description

A colleague built the following VPC environment. They say everything is working but cannot explain why private instances can't reach the internet.

- **VPC:** `10.0.0.0/16`, DNS hostnames enabled, DNS support enabled
- **Public Subnet 1:** `10.0.1.0/24`, AZ `us-east-1a`, auto-assign public IP: **disabled**
- **Public Subnet 2:** `10.0.2.0/24`, AZ `us-east-1b`, auto-assign public IP: enabled
- **Private Subnet 1:** `10.0.10.0/24`, AZ `us-east-1a`
- **Private Subnet 2:** `10.0.20.0/24`, AZ `us-east-1b`
- **Internet Gateway:** Created and attached to the VPC
- **NAT Gateway:** Created in **Private Subnet 1**, has an Elastic IP
- **Public Route Table:** Route `0.0.0.0/0` → Internet Gateway. Associated with Public Subnet 1 and Public Subnet 2.
- **Private Route Table:** Route `0.0.0.0/0` → NAT Gateway. Associated with Private Subnet 1 and Private Subnet 2.
- **Bastion Security Group:** Inbound: SSH from `0.0.0.0/0`
- **Bastion Host:** Launched in Public Subnet 1

### Your Task

List every error in this environment. For each one:
1. State what is wrong
2. State what the correct configuration should be
3. State what the real-world impact is

There are **4 errors** in this environment description.

*(Answers at the bottom of this file — only check after you've written your own list)*

---

## Stage 3 — Solution: Step-by-Step Walkthrough

Use this for actual deployment after completing Stages 1 and 2.

### Step 1 — Create the VPC

1. Navigate to **VPC** → **Your VPCs** → **Create VPC**
2. Select **VPC only**
3. Configure:
   - **Name tag**: `cloud-engineer-01-vpc`
   - **IPv4 CIDR**: `10.0.0.0/16`
   - **Tenancy**: Default
4. Click **Create VPC**
5. Select the new VPC → **Actions** → **Edit VPC settings**
6. Enable both **DNS hostnames** and **DNS resolution** → **Save**

### Step 2 — Create Subnets

Navigate to **VPC** → **Subnets** → **Create subnet**, select your VPC, and add all four:

| Subnet Name | CIDR | AZ |
|---|---|---|
| `cloud-engineer-01-public-1` | `10.0.1.0/24` | `us-east-1a` |
| `cloud-engineer-01-public-2` | `10.0.2.0/24` | `us-east-1b` |
| `cloud-engineer-01-private-1` | `10.0.10.0/24` | `us-east-1a` |
| `cloud-engineer-01-private-2` | `10.0.20.0/24` | `us-east-1b` |

For each **public** subnet: select it → **Actions** → **Edit subnet settings** → **Enable auto-assign public IPv4 address** → **Save**

### Step 3 — Create and Attach the Internet Gateway

1. **VPC** → **Internet gateways** → **Create internet gateway**
2. Name: `cloud-engineer-01-igw` → **Create**
3. **Actions** → **Attach to VPC** → select `cloud-engineer-01-vpc` → **Attach**

### Step 4 — Create the NAT Gateway

1. **VPC** → **NAT gateways** → **Create NAT gateway**
2. Configure:
   - **Name**: `cloud-engineer-01-nat`
   - **Subnet**: `cloud-engineer-01-public-1` ← must be public
   - **Connectivity type**: Public
3. Click **Allocate Elastic IP**
4. Click **Create NAT gateway**

Wait for status to show **Available** before proceeding.

### Step 5 — Create Route Tables

**Public Route Table:**
1. **VPC** → **Route tables** → **Create route table** → Name: `cloud-engineer-01-public-rt`, VPC: yours
2. **Routes** → **Edit routes** → Add: `0.0.0.0/0` → Internet Gateway `cloud-engineer-01-igw`
3. **Subnet associations** → **Edit** → check both public subnets

**Private Route Table:**
1. Create: `cloud-engineer-01-private-rt`
2. **Routes** → **Edit routes** → Add: `0.0.0.0/0` → NAT Gateway `cloud-engineer-01-nat`
3. **Subnet associations** → **Edit** → check both private subnets

### Step 6 — Create Security Groups

**Bastion SG:**
1. **VPC** → **Security groups** → **Create security group**
2. Name: `cloud-engineer-01-bastion-sg`, VPC: yours
3. Inbound: SSH, Source: Custom, `YOUR.IP.HERE/32`
4. Outbound: leave default

**Private SG:**
1. Name: `cloud-engineer-01-private-sg`
2. Inbound: SSH, Source: Custom, select `cloud-engineer-01-bastion-sg`

### Step 7 — Launch the Bastion Host

1. **EC2** → **Launch instances**
2. Name: `cloud-engineer-01-bastion`
3. AMI: Amazon Linux 2 (latest)
4. Instance type: `t3.micro`
5. Key pair: your existing key pair
6. Network: VPC: yours, Subnet: `cloud-engineer-01-public-1`, Auto-assign public IP: **Enable**
7. Security group: `cloud-engineer-01-bastion-sg`
8. Launch

### Verify

SSH to the bastion public IP:
```bash
ssh -i ~/.ssh/your-key.pem ec2-user@<BASTION_PUBLIC_IP>
```

From the bastion:
```bash
curl https://checkip.amazonaws.com
# Returns the NAT Gateway's public IP — not the bastion's IP
```

### Teardown (reverse order)

1. EC2 → terminate bastion
2. VPC → NAT gateways → delete `cloud-engineer-01-nat` → wait for Deleted
3. VPC → Elastic IPs → release the EIP used by the NAT Gateway
4. VPC → Route tables → delete public and private route tables
5. VPC → Security groups → delete private SG, then bastion SG
6. VPC → Subnets → delete all four
7. VPC → Internet gateways → detach, then delete
8. VPC → Your VPCs → delete `cloud-engineer-01-vpc`

---

## Stage 2 Answer Key

*(Only read after completing your own list)*

<details>
<summary>Click to reveal answers</summary>

**Error 1 — Public Subnet 1 has auto-assign public IP disabled**
- What's wrong: `cloud-engineer-01-public-1` has auto-assign public IPv4 disabled
- Correct: Should be enabled on all public subnets
- Impact: Bastion host launched in this subnet will not get a public IP and cannot be reached

**Error 2 — NAT Gateway is in a private subnet**
- What's wrong: NAT Gateway is in Private Subnet 1, which has no route to the internet
- Correct: NAT Gateway must be in a public subnet (one with a route to the IGW)
- Impact: NAT Gateway itself has no internet access, so private instances cannot reach the internet even though the route table points to the NAT

**Error 3 — Bastion security group allows SSH from anywhere**
- What's wrong: `0.0.0.0/0` on port 22 allows the entire internet to attempt SSH connections
- Correct: Should be restricted to your specific IP only (e.g., `203.0.113.10/32`)
- Impact: The bastion is exposed to brute-force attacks from the entire internet

**Error 4 — (this one you had to find yourself)**
- The private route table correctly points to the NAT Gateway, but the NAT Gateway is broken (Error 2), so the route is effectively useless. This is why private instances cannot reach the internet — it's a cascading failure from Error 2.

</details>
