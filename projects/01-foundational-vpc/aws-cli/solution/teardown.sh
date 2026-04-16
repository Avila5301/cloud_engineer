#!/bin/bash
set -euo pipefail

# ============================================================
# Project 01 — Foundational VPC Network
# AWS CLI Teardown Script
# ============================================================

IDS_FILE="$(dirname "$0")/resource-ids.env"

if [[ ! -f "$IDS_FILE" ]]; then
  echo "ERROR: $IDS_FILE not found. Did you run deploy.sh first?"
  exit 1
fi

# shellcheck source=/dev/null
source "$IDS_FILE"

echo "===================================================="
echo " Project 01 — Teardown"
echo " Region: $AWS_REGION"
echo "===================================================="
echo ""
echo "The following resources will be DELETED:"
echo "  EC2 Instance : $BASTION_INSTANCE_ID"
echo "  NAT Gateway  : $NAT_GW_ID"
echo "  Elastic IP   : $EIP_ALLOC_ID"
echo "  Route Tables : $PUB_RT_ID, $PRIV_RT_ID"
echo "  Security Groups: $BASTION_SG_ID, $PRIVATE_SG_ID"
echo "  Subnets      : $PUB_SUBNET_1, $PUB_SUBNET_2, $PRIV_SUBNET_1, $PRIV_SUBNET_2"
echo "  IGW          : $IGW_ID"
echo "  VPC          : $VPC_ID"
echo ""
read -rp "Type 'yes' to confirm deletion: " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
  echo "Teardown cancelled."
  exit 0
fi

# ---- 1. Terminate EC2 instance ----
echo "[1/9] Terminating Bastion Host..."
aws ec2 terminate-instances --instance-ids "$BASTION_INSTANCE_ID" --region "$AWS_REGION"
echo "  Waiting for instance to terminate..."
aws ec2 wait instance-terminated --instance-ids "$BASTION_INSTANCE_ID" --region "$AWS_REGION"
echo "  Instance terminated."

# ---- 2. Delete NAT Gateway ----
echo "[2/9] Deleting NAT Gateway (takes ~1 minute)..."
aws ec2 delete-nat-gateway --nat-gateway-id "$NAT_GW_ID" --region "$AWS_REGION"
echo "  Waiting for NAT Gateway to be deleted..."
aws ec2 wait nat-gateway-deleted --nat-gateway-ids "$NAT_GW_ID" --region "$AWS_REGION"
echo "  NAT Gateway deleted."

# ---- 3. Release Elastic IP ----
echo "[3/9] Releasing Elastic IP..."
aws ec2 release-address --allocation-id "$EIP_ALLOC_ID" --region "$AWS_REGION"
echo "  Elastic IP released."

# ---- 4. Delete route tables (disassociate first) ----
echo "[4/9] Deleting route tables..."
# Disassociate all non-main associations
for RT_ID in "$PUB_RT_ID" "$PRIV_RT_ID"; do
  ASSOC_IDS=$(aws ec2 describe-route-tables \
    --route-table-ids "$RT_ID" --region "$AWS_REGION" \
    --query 'RouteTables[0].Associations[?Main==`false`].RouteTableAssociationId' \
    --output text)
  for ASSOC_ID in $ASSOC_IDS; do
    aws ec2 disassociate-route-table --association-id "$ASSOC_ID" --region "$AWS_REGION"
  done
  aws ec2 delete-route-table --route-table-id "$RT_ID" --region "$AWS_REGION"
  echo "  Deleted route table: $RT_ID"
done

# ---- 5. Delete security groups ----
echo "[5/9] Deleting security groups..."
aws ec2 delete-security-group --group-id "$PRIVATE_SG_ID" --region "$AWS_REGION"
echo "  Deleted: $PRIVATE_SG_ID"
aws ec2 delete-security-group --group-id "$BASTION_SG_ID" --region "$AWS_REGION"
echo "  Deleted: $BASTION_SG_ID"

# ---- 6. Delete subnets ----
echo "[6/9] Deleting subnets..."
for SUBNET_ID in "$PUB_SUBNET_1" "$PUB_SUBNET_2" "$PRIV_SUBNET_1" "$PRIV_SUBNET_2"; do
  aws ec2 delete-subnet --subnet-id "$SUBNET_ID" --region "$AWS_REGION"
  echo "  Deleted: $SUBNET_ID"
done

# ---- 7. Detach and delete Internet Gateway ----
echo "[7/9] Detaching and deleting Internet Gateway..."
aws ec2 detach-internet-gateway --internet-gateway-id "$IGW_ID" --vpc-id "$VPC_ID" --region "$AWS_REGION"
aws ec2 delete-internet-gateway --internet-gateway-id "$IGW_ID" --region "$AWS_REGION"
echo "  IGW deleted: $IGW_ID"

# ---- 8. Delete VPC ----
echo "[8/9] Deleting VPC..."
aws ec2 delete-vpc --vpc-id "$VPC_ID" --region "$AWS_REGION"
echo "  VPC deleted: $VPC_ID"

# ---- 9. Clean up IDs file ----
echo "[9/9] Removing resource IDs file..."
rm -f "$IDS_FILE"

echo ""
echo "===================================================="
echo " Teardown Complete. All resources deleted."
echo "===================================================="
