terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ============================================================
# TODO: VPC
#
# Create a VPC with:
#   - CIDR block from var.vpc_cidr
#   - DNS hostnames enabled
#   - DNS support enabled
#   - Tags: merge var.common_tags with Name = "${var.project_name}-vpc"
# ============================================================

# resource "aws_vpc" ... {
#
# }

# ============================================================
# TODO: Public Subnets
#
# Create public subnets using count over var.public_subnet_cidrs.
# Each subnet should:
#   - Belong to the VPC above
#   - Use the CIDR from var.public_subnet_cidrs[count.index]
#   - Be in the AZ from var.availability_zones[count.index]
#   - Auto-assign public IPs to instances launched in it
#   - Be tagged with Tier = "public"
# ============================================================

# resource "aws_subnet" "public" {
#
# }

# ============================================================
# TODO: Private Subnets
#
# Same structure as public subnets, but using var.private_subnet_cidrs.
# Do NOT enable auto-assign public IP.
# Tag with Tier = "private".
# ============================================================

# resource "aws_subnet" "private" {
#
# }

# ============================================================
# TODO: Internet Gateway
#
# Attach it to the VPC.
# ============================================================

# resource "aws_internet_gateway" "main" {
#
# }

# ============================================================
# TODO: Elastic IP for NAT Gateway
#
# - Domain must be "vpc"
# - Add depends_on referencing the internet gateway
#   (Why? The IGW must be attached before the NAT Gateway can use it)
# ============================================================

# resource "aws_eip" "nat" {
#
# }

# ============================================================
# TODO: NAT Gateway
#
# - Use the EIP allocation above
# - Place it in the FIRST public subnet (index 0)
# - Add depends_on referencing the internet gateway
#
# Question: Why must the NAT Gateway go in a public subnet?
# ============================================================

# resource "aws_nat_gateway" "main" {
#
# }

# ============================================================
# TODO: Public Route Table
#
# - Add a route: 0.0.0.0/0 → Internet Gateway
# - Tag it as "${var.project_name}-public-rt"
# ============================================================

# resource "aws_route_table" "public" {
#
# }

# ============================================================
# TODO: Associate Public Subnets with the Public Route Table
#
# Use count to associate each public subnet.
# ============================================================

# resource "aws_route_table_association" "public" {
#
# }

# ============================================================
# TODO: Private Route Table
#
# - Add a route: 0.0.0.0/0 → NAT Gateway (not IGW)
# - Tag it as "${var.project_name}-private-rt"
# ============================================================

# resource "aws_route_table" "private" {
#
# }

# ============================================================
# TODO: Associate Private Subnets with the Private Route Table
# ============================================================

# resource "aws_route_table_association" "private" {
#
# }

# ============================================================
# TODO: Bastion Security Group
#
# Inbound:
#   - SSH (port 22) from var.admin_ip_cidr ONLY
# Outbound:
#   - All traffic allowed
#
# Do not open SSH to 0.0.0.0/0. This is a real security risk.
# ============================================================

# resource "aws_security_group" "bastion" {
#
# }

# ============================================================
# TODO: Private Instance Security Group
#
# Inbound:
#   - SSH (port 22) from the bastion security group only
#     Use security_groups = [aws_security_group.bastion.id]
#     NOT a cidr_blocks entry
# Outbound:
#   - All traffic allowed
# ============================================================

# resource "aws_security_group" "private" {
#
# }

# ============================================================
# TODO: Bastion Host EC2 Instance
#
# - AMI: var.bastion_ami_id
# - Instance type: var.bastion_instance_type
# - Subnet: first public subnet
# - Security group: bastion security group
# - Key pair: var.key_pair_name
# ============================================================

# resource "aws_instance" "bastion" {
#
# }
