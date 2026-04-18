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
IDS_FILE="$(dirname "$0")/resource-ids.env"

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

# Start Here
VPC_ID=""  # TODO: replace with the aws ec2 create-vpc command output

# (Remove this comment after placing each AWS CLI command below)
# TODO: enable DNS hostnames on the VPC
# TODO: enable DNS support on the VPC
# TODO: tag the VPC

echo "  VPC: $VPC_ID"

# End: Create the VPC section


# ============================================================
# TODO: Create Public Subnet 1
#
# CIDR: 10.0.1.0/24
# AZ: $AZ1
# After creating, enable auto-assign public IP on this subnet.
# Tag it as "${PROJECT_TAG}-public-1" with Project="${PROJECT_TAG}".
#
# Hint: capture the subnet ID using --query 'Subnet.SubnetId' --output text
# ============================================================
echo "[2/14] Creating public subnet 1 ($AZ1)..."

# Start Here
PUB_SUBNET_1=""  # TODO: replace with the aws ec2 create-subnet command output

# (Remove this comment after placing each AWS CLI command below)
# TODO: enable map-public-ip-on-launch on this subnet
# TODO: tag the subnet

echo "  Public Subnet 1: $PUB_SUBNET_1"

# End: Create Public Subnet 1 section


# ============================================================
# TODO: Create Public Subnet 2
#
# CIDR: 10.0.2.0/24
# AZ: $AZ2
# Follow the same steps as Public Subnet 1.
# Tag it as "${PROJECT_TAG}-public-2".
# ============================================================
echo "[3/14] Creating public subnet 2 ($AZ2)..."

# Start Here
PUB_SUBNET_2=""  # TODO: replace with the aws ec2 create-subnet command output

# (Remove this comment after placing each AWS CLI command below)
# TODO: enable map-public-ip-on-launch on this subnet
# TODO: tag the subnet

echo "  Public Subnet 2: $PUB_SUBNET_2"

# End: Create Public Subnet 2 section


# ============================================================
# TODO: Create Private Subnet 1
#
# CIDR: 10.0.10.0/24
# AZ: $AZ1
# Do NOT enable auto-assign public IP — private subnets stay private.
# Tag it as "${PROJECT_TAG}-private-1" with Project="${PROJECT_TAG}".
# ============================================================
echo "[4/14] Creating private subnet 1 ($AZ1)..."

# Start Here
PRIV_SUBNET_1=""  # TODO: replace with the aws ec2 create-subnet command output

# (Remove this comment after placing each AWS CLI command below)
# TODO: tag the subnet

echo "  Private Subnet 1: $PRIV_SUBNET_1"

# End: Create Private Subnet 1 section


# ============================================================
# TODO: Create Private Subnet 2
#
# CIDR: 10.0.20.0/24
# AZ: $AZ2
# Follow the same steps as Private Subnet 1.
# Tag it as "${PROJECT_TAG}-private-2".
# ============================================================
echo "[5/14] Creating private subnet 2 ($AZ2)..."

# Start Here
PRIV_SUBNET_2=""  # TODO: replace with the aws ec2 create-subnet command output

# (Remove this comment after placing each AWS CLI command below)
# TODO: tag the subnet

echo "  Private Subnet 2: $PRIV_SUBNET_2"

# End: Create Private Subnet 2 section


# ============================================================
# TODO: Create the Internet Gateway
#
# Create an IGW, then attach it to your VPC — these are two
# separate commands. Tag it as "${PROJECT_TAG}-igw".
#
# Hint: capture the IGW ID using --query 'InternetGateway.InternetGatewayId' --output text
# ============================================================
echo "[6/14] Creating Internet Gateway..."

# Start Here
IGW_ID=""  # TODO: replace with the aws ec2 create-internet-gateway command output

# (Remove this comment after placing each AWS CLI command below)
# TODO: attach the IGW to the VPC
# TODO: tag the IGW

echo "  IGW: $IGW_ID"

# End: Create Internet Gateway section


# ============================================================
# TODO: Allocate an Elastic IP for the NAT Gateway
#
# Allocate an EIP in the 'vpc' domain.
# Capture the AllocationId — you will need it when creating the NAT Gateway.
#
# Note: AWS charges $0.005/hr for all public IPv4 addresses.
# Always release this EIP during teardown.
#
# Hint: capture using --query 'AllocationId' --output text
# ============================================================
echo "[7/14] Allocating Elastic IP..."

# Start Here
EIP_ALLOC_ID=""  # TODO: replace with the aws ec2 allocate-address command output

echo "  EIP Allocation: $EIP_ALLOC_ID"

# End: Allocate Elastic IP section


# ============================================================
# TODO: Create the NAT Gateway
#
# IMPORTANT: Which subnet should the NAT Gateway go in?
# Think carefully — placing it in the wrong subnet is one of
# the most common mistakes in this project.
#
# After creating it, wait for it to reach the 'available' state
# before creating any routes that reference it.
#
# Hint: capture the NAT GW ID using --query 'NatGateway.NatGatewayId' --output text
# ============================================================
echo "[8/14] Creating NAT Gateway..."

# Start Here
NAT_GW_ID=""  # TODO: replace with the aws ec2 create-nat-gateway command output

echo "  NAT Gateway: $NAT_GW_ID"
echo "  Waiting for NAT Gateway to become available..."

# (Remove this comment after placing the wait command below)
# TODO: wait for the NAT Gateway to be available (aws ec2 wait nat-gateway-available)

echo "  NAT Gateway is available."

# End: Create NAT Gateway section


# ============================================================
# TODO: Create the Public Route Table
#
# Create a route table in the VPC.
# Add a route: destination 0.0.0.0/0 → Internet Gateway.
# Associate it with BOTH public subnets.
# Tag it as "${PROJECT_TAG}-public-rt".
#
# Hint: capture the route table ID using --query 'RouteTable.RouteTableId' --output text
# ============================================================
echo "[9/14] Creating public route table..."

# Start Here
PUB_RT_ID=""  # TODO: replace with the aws ec2 create-route-table command output

# (Remove this comment after placing each AWS CLI command below)
# TODO: add a route for 0.0.0.0/0 pointing to the IGW
# TODO: associate the route table with PUB_SUBNET_1
# TODO: associate the route table with PUB_SUBNET_2
# TODO: tag the route table

echo "  Public Route Table: $PUB_RT_ID"

# End: Create Public Route Table section


# ============================================================
# TODO: Create the Private Route Table
#
# Same structure as the public route table, but the 0.0.0.0/0
# route should point to the NAT Gateway — not the IGW.
# Associate it with BOTH private subnets.
# Tag it as "${PROJECT_TAG}-private-rt".
# ============================================================
echo "[10/14] Creating private route table..."

# Start Here
PRIV_RT_ID=""  # TODO: replace with the aws ec2 create-route-table command output

# (Remove this comment after placing each AWS CLI command below)
# TODO: add a route for 0.0.0.0/0 pointing to the NAT Gateway
# TODO: associate the route table with PRIV_SUBNET_1
# TODO: associate the route table with PRIV_SUBNET_2
# TODO: tag the route table

echo "  Private Route Table: $PRIV_RT_ID"

# End: Create Private Route Table section


# ============================================================
# TODO: Create the Bastion Security Group
#
# Allow inbound SSH (port 22) from YOUR IP only ($YOUR_IP).
# Do not open SSH to 0.0.0.0/0 — this is a common and serious mistake.
# Allow all outbound traffic.
# Tag it as "${PROJECT_TAG}-bastion-sg".
#
# Hint: capture the SG ID using --query 'GroupId' --output text
# ============================================================
echo "[11/14] Creating Bastion security group..."

# Start Here
BASTION_SG_ID=""  # TODO: replace with the aws ec2 create-security-group command output

# (Remove this comment after placing each AWS CLI command below)
# TODO: add an inbound rule — SSH (port 22) from $YOUR_IP only
# TODO: tag the security group

echo "  Bastion SG: $BASTION_SG_ID"

# End: Create Bastion Security Group section


# ============================================================
# TODO: Create the Private Instance Security Group
#
# Allow inbound SSH only from the Bastion Security Group — not an IP range.
# This means only instances inside the bastion SG can SSH into private instances.
# Allow all outbound traffic.
# Tag it as "${PROJECT_TAG}-private-sg".
#
# Hint: to allow traffic from a security group use --source-group $BASTION_SG_ID
#       instead of --cidr
# ============================================================
echo "[12/14] Creating private instance security group..."

# Start Here
PRIVATE_SG_ID=""  # TODO: replace with the aws ec2 create-security-group command output

# (Remove this comment after placing each AWS CLI command below)
# TODO: add an inbound rule — SSH (port 22) from the BASTION_SG_ID (not an IP)
# TODO: tag the security group

echo "  Private SG: $PRIVATE_SG_ID"

# End: Create Private Instance Security Group section


# ============================================================
# TODO: Launch the Bastion Host EC2 Instance
#
# Launch a $INSTANCE_TYPE instance in $PUB_SUBNET_1 using:
#   - Your AMI ($AMI_ID)
#   - Your key pair ($KEY_PAIR_NAME)
#   - The bastion security group ($BASTION_SG_ID)
#   - Associate a public IP so you can SSH in
#
# After launching, wait for it to reach the 'running' state,
# then retrieve and store its public IP address.
#
# Hint: capture the instance ID using --query 'Instances[0].InstanceId' --output text
# Hint: get the public IP using describe-instances with --query 'Reservations[0].Instances[0].PublicIpAddress'
# ============================================================
echo "[13/14] Launching Bastion Host..."

# Start Here
BASTION_INSTANCE_ID=""  # TODO: replace with the aws ec2 run-instances command output

echo "  Bastion Instance: $BASTION_INSTANCE_ID"
echo "  Waiting for bastion to be running..."

# (Remove this comment after placing each AWS CLI command below)
# TODO: wait for the instance to be in the running state
# TODO: retrieve and store the public IP into BASTION_PUBLIC_IP

BASTION_PUBLIC_IP=""  # TODO: replace with describe-instances query output

# End: Launch Bastion Host section


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
echo "===================================================="
