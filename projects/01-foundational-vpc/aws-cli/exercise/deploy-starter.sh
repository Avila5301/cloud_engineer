#!/bin/bash
set -euo pipefail

# ============================================================
# Project 01 — Foundational VPC Network
# AWS CLI Deploy Script — EXERCISE VERSION
#
# Instructions:
# Fill in every section marked with # TODO.
# Do not look at the solution folder until you have made
# a genuine attempt at each section.
# ============================================================

# ============================================================
# TODO: Set your configuration variables
# Fill in the correct values for each variable below.
# ============================================================
AWS_REGION=""                # e.g. "us-east-1"
AZ1=""                       # e.g. "us-east-1a" — first availability zone
AZ2=""                       # e.g. "us-east-1b" — second availability zone
KEY_PAIR_NAME=""             # Name of your existing EC2 key pair
YOUR_IP="$(curl -s https://checkip.amazonaws.com)/32"   # Auto-detects — leave as-is
AMI_ID=""                    # Amazon Linux 2 AMI ID for your region
INSTANCE_TYPE=""             # Use a t3.micro to stay cost-efficient
PROJECT_TAG="cloud-engineer-01"
IDS_FILE="$(dirname "$0")/../solution/resource-ids.env"

echo "===================================================="
echo " Project 01 — Foundational VPC Network (Exercise)"
echo " Region : $AWS_REGION"
echo " Your IP: $YOUR_IP"
echo "===================================================="

# ============================================================
# TODO: Create the VPC
#
# Create a VPC with CIDR block 10.0.0.0/16.
# After creating it, enable DNS hostnames and DNS support.
# Tag it with Name="${PROJECT_TAG}-vpc" and Project="${PROJECT_TAG}".
#
# Hint: capture the VPC ID using --query 'Vpc.VpcId' --output text
# ============================================================
echo "[1/14] Creating VPC..."

VPC_ID=""  # TODO: replace with the aws ec2 create-vpc command output

# TODO: enable DNS hostnames on the VPC
# TODO: enable DNS support on the VPC
# TODO: tag the VPC

echo "  VPC: $VPC_ID"

# ============================================================
# TODO: Create Public Subnet 1
#
# CIDR: 10.0.1.0/24
# AZ: $AZ1
# After creating, enable auto-assign public IP on this subnet.
# Tag it as "${PROJECT_TAG}-public-1"
# ============================================================
echo "[2/14] Creating public subnet 1 ($AZ1)..."

PUB_SUBNET_1=""  # TODO: replace with create-subnet command

# TODO: enable map-public-ip-on-launch
# TODO: tag the subnet

echo "  Public Subnet 1: $PUB_SUBNET_1"

# ============================================================
# TODO: Create Public Subnet 2
#
# CIDR: 10.0.2.0/24
# AZ: $AZ2
# Same requirements as Public Subnet 1.
# ============================================================
echo "[3/14] Creating public subnet 2 ($AZ2)..."

PUB_SUBNET_2=""  # TODO

echo "  Public Subnet 2: $PUB_SUBNET_2"

# ============================================================
# TODO: Create Private Subnet 1
#
# CIDR: 10.0.10.0/24
# AZ: $AZ1
# Do NOT enable auto-assign public IP.
# Tag it as "${PROJECT_TAG}-private-1"
# ============================================================
echo "[4/14] Creating private subnet 1 ($AZ1)..."

PRIV_SUBNET_1=""  # TODO

echo "  Private Subnet 1: $PRIV_SUBNET_1"

# ============================================================
# TODO: Create Private Subnet 2
#
# CIDR: 10.0.20.0/24
# AZ: $AZ2
# ============================================================
echo "[5/14] Creating private subnet 2 ($AZ2)..."

PRIV_SUBNET_2=""  # TODO

echo "  Private Subnet 2: $PRIV_SUBNET_2"

# ============================================================
# TODO: Create the Internet Gateway
#
# Create an IGW, attach it to your VPC, and tag it.
# Hint: attachment is a separate command from creation.
# ============================================================
echo "[6/14] Creating Internet Gateway..."

IGW_ID=""  # TODO

echo "  IGW: $IGW_ID"

# ============================================================
# TODO: Allocate an Elastic IP for the NAT Gateway
#
# Allocate an EIP in the 'vpc' domain.
# Capture the AllocationId — you'll need it for the NAT Gateway.
#
# Note: As of 2024, AWS charges $0.005/hr for all public IPv4
# addresses, whether attached or not. Release this EIP during teardown.
# ============================================================
echo "[7/14] Allocating Elastic IP..."

EIP_ALLOC_ID=""  # TODO

echo "  EIP Allocation: $EIP_ALLOC_ID"

# ============================================================
# TODO: Create the NAT Gateway
#
# IMPORTANT: Which subnet should the NAT Gateway go in?
# Think about this carefully — it is one of the most common mistakes.
#
# After creating it, wait for it to become available before
# creating any routes that reference it.
# ============================================================
echo "[8/14] Creating NAT Gateway..."

NAT_GW_ID=""  # TODO

echo "  NAT Gateway: $NAT_GW_ID"
echo "  Waiting for NAT Gateway to become available..."
# TODO: wait command here
echo "  NAT Gateway is available."

# ============================================================
# TODO: Create the Public Route Table
#
# Create a route table, add a route for 0.0.0.0/0 pointing to
# the Internet Gateway, then associate it with BOTH public subnets.
# ============================================================
echo "[9/14] Creating public route table..."

PUB_RT_ID=""  # TODO

echo "  Public Route Table: $PUB_RT_ID"

# ============================================================
# TODO: Create the Private Route Table
#
# Same structure as the public route table, but the 0.0.0.0/0
# route should point to the NAT Gateway — not the IGW.
# Associate with both private subnets.
# ============================================================
echo "[10/14] Creating private route table..."

PRIV_RT_ID=""  # TODO

echo "  Private Route Table: $PRIV_RT_ID"

# ============================================================
# TODO: Create the Bastion Security Group
#
# Allow inbound SSH (port 22) from YOUR IP only ($YOUR_IP).
# Do not open it to 0.0.0.0/0 — this is a common and serious mistake.
# Allow all outbound traffic.
# ============================================================
echo "[11/14] Creating Bastion security group..."

BASTION_SG_ID=""  # TODO

echo "  Bastion SG: $BASTION_SG_ID"

# ============================================================
# TODO: Create the Private Instance Security Group
#
# Allow inbound SSH only from the Bastion Security Group (not an IP range).
# This means only traffic from instances in the bastion SG can SSH in.
# Hint: use --source-group instead of --cidr
# ============================================================
echo "[12/14] Creating private instance security group..."

PRIVATE_SG_ID=""  # TODO

echo "  Private SG: $PRIVATE_SG_ID"

# ============================================================
# TODO: Launch the Bastion Host EC2 Instance
#
# Launch a $INSTANCE_TYPE in $PUB_SUBNET_1 with the bastion SG.
# Assign a public IP. Use your key pair.
# After launching, wait for it to reach the running state.
# Then retrieve and store its public IP.
# ============================================================
echo "[13/14] Launching Bastion Host..."

BASTION_INSTANCE_ID=""  # TODO

echo "  Bastion Instance: $BASTION_INSTANCE_ID"
echo "  Waiting for bastion to be running..."
# TODO: wait command
# TODO: get the public IP

BASTION_PUBLIC_IP=""  # TODO: retrieve after instance is running

# ============================================================
# Save resource IDs — do not modify this section
# ============================================================
echo "[14/14] Saving resource IDs..."
cat > "$IDS_FILE" <<EOF
VPC_ID=$VPC_ID
PUB_SUBNET_1=$PUB_SUBNET_1
PUB_SUBNET_2=$PUB_SUBNET_2
PRIV_SUBNET_1=$PRIV_SUBNET_1
PRIV_SUBNET_2=$PRIV_SUBNET_2
IGW_ID=$IGW_ID
EIP_ALLOC_ID=$EIP_ALLOC_ID
NAT_GW_ID=$NAT_GW_ID
PUB_RT_ID=$PUB_RT_ID
PRIV_RT_ID=$PRIV_RT_ID
BASTION_SG_ID=$BASTION_SG_ID
PRIVATE_SG_ID=$PRIVATE_SG_ID
BASTION_INSTANCE_ID=$BASTION_INSTANCE_ID
AWS_REGION=$AWS_REGION
EOF

echo ""
echo "===================================================="
echo " Deployment Complete!"
echo "===================================================="
echo " VPC ID       : $VPC_ID"
echo " Bastion Host : $BASTION_PUBLIC_IP"
echo " SSH Command  : ssh -i ~/.ssh/${KEY_PAIR_NAME}.pem ec2-user@${BASTION_PUBLIC_IP}"
echo " Run teardown : solution/teardown.sh"
echo "===================================================="
