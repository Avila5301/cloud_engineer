#!/bin/bash
set -euo pipefail

# ============================================================
# Project 01 — Foundational VPC Network
# AWS CLI Deploy Script — TROUBLESHOOT VERSION
#
# This script contains 5 intentional errors.
# Find and fix them before comparing to the solution.
# Do not run this script until you have identified all 5 errors.
# ============================================================

AWS_REGION="us-east-1"
AZ1="us-east-1a"
AZ2="us-east-1b"
KEY_PAIR_NAME="your-key-pair-name"
YOUR_IP="$(curl -s https://checkip.amazonaws.com)/32"
AMI_ID="ami-0c02fb55956c7d316"
INSTANCE_TYPE="t3.micro"
PROJECT_TAG="cloud-engineer-01"
IDS_FILE="$(dirname "$0")/../solution/resource-ids.env"

echo "===================================================="
echo " Project 01 — Foundational VPC Network"
echo " Region : $AWS_REGION"
echo " Your IP: $YOUR_IP"
echo "===================================================="

echo "[1/14] Creating VPC..."
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block 10.0.0.0/16 \
  --region "$AWS_REGION" \
  --query 'Vpc.VpcId' --output text)

aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-hostnames --region "$AWS_REGION"
aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-support --region "$AWS_REGION"
aws ec2 create-tags --resources "$VPC_ID" --tags Key=Name,Value="${PROJECT_TAG}-vpc" Key=Project,Value="$PROJECT_TAG" --region "$AWS_REGION"
echo "  VPC: $VPC_ID"

echo "[2/14] Creating public subnet 1 ($AZ1)..."
PUB_SUBNET_1=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" --cidr-block 10.0.1.0/24 \
  --availability-zone "$AZ1" --region "$AWS_REGION" \
  --query 'Subnet.SubnetId' --output text)
aws ec2 modify-subnet-attribute --subnet-id "$PUB_SUBNET_1" --map-public-ip-on-launch --region "$AWS_REGION"
aws ec2 create-tags --resources "$PUB_SUBNET_1" --tags Key=Name,Value="${PROJECT_TAG}-public-1" Key=Project,Value="$PROJECT_TAG" --region "$AWS_REGION"
echo "  Public Subnet 1: $PUB_SUBNET_1"

echo "[3/14] Creating public subnet 2 ($AZ2)..."
PUB_SUBNET_2=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" --cidr-block 10.0.2.0/24 \
  --availability-zone "$AZ2" --region "$AWS_REGION" \
  --query 'Subnet.SubnetId' --output text)
aws ec2 modify-subnet-attribute --subnet-id "$PUB_SUBNET_2" --map-public-ip-on-launch --region "$AWS_REGION"
aws ec2 create-tags --resources "$PUB_SUBNET_2" --tags Key=Name,Value="${PROJECT_TAG}-public-2" Key=Project,Value="$PROJECT_TAG" --region "$AWS_REGION"
echo "  Public Subnet 2: $PUB_SUBNET_2"

# ERROR 4 — one of the private subnet CIDRs conflicts with an existing subnet
echo "[4/14] Creating private subnet 1 ($AZ1)..."
PRIV_SUBNET_1=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" --cidr-block 10.0.1.0/24 \
  --availability-zone "$AZ1" --region "$AWS_REGION" \
  --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources "$PRIV_SUBNET_1" --tags Key=Name,Value="${PROJECT_TAG}-private-1" Key=Project,Value="$PROJECT_TAG" --region "$AWS_REGION"
echo "  Private Subnet 1: $PRIV_SUBNET_1"

echo "[5/14] Creating private subnet 2 ($AZ2)..."
PRIV_SUBNET_2=$(aws ec2 create-subnet \
  --vpc-id "$VPC_ID" --cidr-block 10.0.20.0/24 \
  --availability-zone "$AZ2" --region "$AWS_REGION" \
  --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources "$PRIV_SUBNET_2" --tags Key=Name,Value="${PROJECT_TAG}-private-2" Key=Project,Value="$PROJECT_TAG" --region "$AWS_REGION"
echo "  Private Subnet 2: $PRIV_SUBNET_2"

echo "[6/14] Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
  --region "$AWS_REGION" \
  --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --internet-gateway-id "$IGW_ID" --vpc-id "$VPC_ID" --region "$AWS_REGION"
aws ec2 create-tags --resources "$IGW_ID" --tags Key=Name,Value="${PROJECT_TAG}-igw" Key=Project,Value="$PROJECT_TAG" --region "$AWS_REGION"
echo "  IGW: $IGW_ID"

echo "[7/14] Allocating Elastic IP..."
EIP_ALLOC_ID=$(aws ec2 allocate-address \
  --domain vpc --region "$AWS_REGION" \
  --query 'AllocationId' --output text)
echo "  EIP Allocation: $EIP_ALLOC_ID"

# ERROR 2 — NAT Gateway is being created in the wrong subnet
echo "[8/14] Creating NAT Gateway..."
NAT_GW_ID=$(aws ec2 create-nat-gateway \
  --subnet-id "$PRIV_SUBNET_1" \
  --allocation-id "$EIP_ALLOC_ID" \
  --region "$AWS_REGION" \
  --query 'NatGateway.NatGatewayId' --output text)
aws ec2 create-tags --resources "$NAT_GW_ID" --tags Key=Name,Value="${PROJECT_TAG}-nat" Key=Project,Value="$PROJECT_TAG" --region "$AWS_REGION"
echo "  NAT Gateway: $NAT_GW_ID"

# ERROR 5 — the wait step is missing; the next commands will fail because
# the NAT Gateway is not yet available when routes are created
echo "  (skipping wait — assuming NAT Gateway is fast)"

# ERROR 3 — public route table is sending traffic to NAT Gateway instead of IGW,
# and private route table is sending traffic to IGW instead of NAT Gateway
echo "[9/14] Creating public route table..."
PUB_RT_ID=$(aws ec2 create-route-table \
  --vpc-id "$VPC_ID" --region "$AWS_REGION" \
  --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id "$PUB_RT_ID" --destination-cidr-block 0.0.0.0/0 --nat-gateway-id "$NAT_GW_ID" --region "$AWS_REGION"
aws ec2 associate-route-table --route-table-id "$PUB_RT_ID" --subnet-id "$PUB_SUBNET_1" --region "$AWS_REGION"
aws ec2 associate-route-table --route-table-id "$PUB_RT_ID" --subnet-id "$PUB_SUBNET_2" --region "$AWS_REGION"
aws ec2 create-tags --resources "$PUB_RT_ID" --tags Key=Name,Value="${PROJECT_TAG}-public-rt" Key=Project,Value="$PROJECT_TAG" --region "$AWS_REGION"
echo "  Public Route Table: $PUB_RT_ID"

echo "[10/14] Creating private route table..."
PRIV_RT_ID=$(aws ec2 create-route-table \
  --vpc-id "$VPC_ID" --region "$AWS_REGION" \
  --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id "$PRIV_RT_ID" --destination-cidr-block 0.0.0.0/0 --gateway-id "$IGW_ID" --region "$AWS_REGION"
aws ec2 associate-route-table --route-table-id "$PRIV_RT_ID" --subnet-id "$PRIV_SUBNET_1" --region "$AWS_REGION"
aws ec2 associate-route-table --route-table-id "$PRIV_RT_ID" --subnet-id "$PRIV_SUBNET_2" --region "$AWS_REGION"
aws ec2 create-tags --resources "$PRIV_RT_ID" --tags Key=Name,Value="${PROJECT_TAG}-private-rt" Key=Project,Value="$PROJECT_TAG" --region "$AWS_REGION"
echo "  Private Route Table: $PRIV_RT_ID"

# ERROR 1 — bastion security group allows SSH from anywhere, not just your IP
echo "[11/14] Creating Bastion security group..."
BASTION_SG_ID=$(aws ec2 create-security-group \
  --group-name "${PROJECT_TAG}-bastion-sg" \
  --description "SSH access to bastion" \
  --vpc-id "$VPC_ID" --region "$AWS_REGION" \
  --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress \
  --group-id "$BASTION_SG_ID" \
  --protocol tcp --port 22 --cidr "0.0.0.0/0" \
  --region "$AWS_REGION"
aws ec2 create-tags --resources "$BASTION_SG_ID" --tags Key=Name,Value="${PROJECT_TAG}-bastion-sg" Key=Project,Value="$PROJECT_TAG" --region "$AWS_REGION"
echo "  Bastion SG: $BASTION_SG_ID"

echo "[12/14] Creating private instance security group..."
PRIVATE_SG_ID=$(aws ec2 create-security-group \
  --group-name "${PROJECT_TAG}-private-sg" \
  --description "SSH access from bastion only" \
  --vpc-id "$VPC_ID" --region "$AWS_REGION" \
  --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress \
  --group-id "$PRIVATE_SG_ID" \
  --protocol tcp --port 22 --source-group "$BASTION_SG_ID" \
  --region "$AWS_REGION"
aws ec2 create-tags --resources "$PRIVATE_SG_ID" --tags Key=Name,Value="${PROJECT_TAG}-private-sg" Key=Project,Value="$PROJECT_TAG" --region "$AWS_REGION"
echo "  Private SG: $PRIVATE_SG_ID"

echo "[13/14] Launching Bastion Host..."
BASTION_INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_PAIR_NAME" \
  --subnet-id "$PUB_SUBNET_1" \
  --security-group-ids "$BASTION_SG_ID" \
  --associate-public-ip-address \
  --region "$AWS_REGION" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${PROJECT_TAG}-bastion},{Key=Project,Value=${PROJECT_TAG}}]" \
  --query 'Instances[0].InstanceId' --output text)
echo "  Bastion Instance: $BASTION_INSTANCE_ID"
aws ec2 wait instance-running --instance-ids "$BASTION_INSTANCE_ID" --region "$AWS_REGION"

BASTION_PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$BASTION_INSTANCE_ID" --region "$AWS_REGION" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

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
echo "===================================================="
