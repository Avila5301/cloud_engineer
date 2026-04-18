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
# Create a VPC with DNS hostnames and DNS support enabled.
# Tags are pre-filled — do not change them.
# ============================================================

# Start Here
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr  # already set — do not change
  enable_dns_hostnames = false          # TODO: should DNS hostnames be enabled? (true/false)
  enable_dns_support   = false          # TODO: should DNS support be enabled? (true/false)

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-vpc"    # already set — do not change
  })
}
# End: VPC


# ============================================================
# TODO: Public Subnets
#
# Create 2 public subnets using count.
# Each subnet must:
#   - Use the correct CIDR from var.public_subnet_cidrs[count.index]
#   - Be placed in the correct AZ from var.availability_zones[count.index]
#   - Auto-assign public IPs to instances launched in it
#
# Hint: count = length(var.public_subnet_cidrs)
# ============================================================

# Start Here
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)  # already set — do not change

  vpc_id            = aws_vpc.main.id      # already set — do not change
  cidr_block        = ""                    # TODO: var.public_subnet_cidrs[count.index]
  availability_zone = ""                    # TODO: var.availability_zones[count.index]

  map_public_ip_on_launch = false           # TODO: should public subnets auto-assign IPs? (true/false)

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-public-${count.index + 1}"  # already set — do not change
    Tier = "public"                                          # already set — do not change
  })
}
# End: Public Subnets


# ============================================================
# TODO: Private Subnets
#
# Same structure as public subnets but:
#   - Use var.private_subnet_cidrs
#   - Do NOT set map_public_ip_on_launch — private subnets stay private
#   - Tag with Tier = "private"
# ============================================================

# Start Here
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)  # already set — do not change

  vpc_id            = aws_vpc.main.id       # already set — do not change
  cidr_block        = ""                     # TODO: var.private_subnet_cidrs[count.index]
  availability_zone = ""                     # TODO: var.availability_zones[count.index]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-private-${count.index + 1}"  # already set — do not change
    Tier = "private"                                          # already set — do not change
  })
}
# End: Private Subnets


# ============================================================
# TODO: Internet Gateway
#
# Create an IGW and attach it to the VPC.
# ============================================================

# Start Here
resource "aws_internet_gateway" "main" {
  vpc_id = ""  # TODO: reference the VPC created above (aws_vpc.main.id)

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-igw"  # already set — do not change
  })
}
# End: Internet Gateway


# ============================================================
# TODO: Elastic IP for NAT Gateway
#
# - Domain must be "vpc"
# - The depends_on is already set — do not remove it
#   (The IGW must exist before the NAT Gateway can route traffic out)
# ============================================================

# Start Here
resource "aws_eip" "nat" {
  domain     = ""                           # TODO: "vpc" or "classic"?
  depends_on = [aws_internet_gateway.main]  # already set — do not change
}
# End: Elastic IP


# ============================================================
# TODO: NAT Gateway
#
# - Use the EIP allocated above
# - Place it in the FIRST public subnet (index 0)
# - The depends_on is already set — do not remove it
#
# Question: Why must the NAT Gateway go in a PUBLIC subnet?
# ============================================================

# Start Here
resource "aws_nat_gateway" "main" {
  allocation_id     = ""                     # TODO: aws_eip.nat.id
  subnet_id         = ""                     # TODO: first public subnet — aws_subnet.public[0].id
  connectivity_type = "public"               # already set — do not change

  depends_on = [aws_internet_gateway.main]   # already set — do not change

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-nat"         # already set — do not change
  })
}
# End: NAT Gateway


# ============================================================
# TODO: Public Route Table
#
# Add a route: destination 0.0.0.0/0 → Internet Gateway.
# ============================================================

# Start Here
resource "aws_route_table" "public" {
  vpc_id = ""  # TODO: reference the VPC created above (aws_vpc.main.id)

  route {
    cidr_block = ""  # TODO: what CIDR covers all internet traffic?
    gateway_id = ""  # TODO: aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-public-rt"  # already set — do not change
  })
}
# End: Public Route Table


# ============================================================
# TODO: Associate Public Subnets with the Public Route Table
#
# Use count to associate each public subnet.
# ============================================================

# Start Here
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)  # already set — do not change

  subnet_id      = ""  # TODO: aws_subnet.public[count.index].id
  route_table_id = ""  # TODO: aws_route_table.public.id
}
# End: Public Route Table Associations


# ============================================================
# TODO: Private Route Table
#
# Same structure as the public route table but:
# - The 0.0.0.0/0 route must point to the NAT Gateway, NOT the IGW
# - Use nat_gateway_id instead of gateway_id in the route block
# ============================================================

# Start Here
resource "aws_route_table" "private" {
  vpc_id = ""  # TODO: reference the VPC created above (aws_vpc.main.id)

  route {
    cidr_block     = ""  # TODO: same destination as public — all internet traffic
    nat_gateway_id = ""  # TODO: aws_nat_gateway.main.id (use nat_gateway_id, not gateway_id)
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-private-rt"  # already set — do not change
  })
}
# End: Private Route Table


# ============================================================
# TODO: Associate Private Subnets with the Private Route Table
# ============================================================

# Start Here
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)  # already set — do not change

  subnet_id      = ""  # TODO: aws_subnet.private[count.index].id
  route_table_id = ""  # TODO: aws_route_table.private.id
}
# End: Private Route Table Associations


# ============================================================
# TODO: Bastion Security Group
#
# Inbound:
#   - SSH (port 22) from var.admin_ip_cidr ONLY
#   - Do NOT open to 0.0.0.0/0 — this is a real security risk
# Outbound:
#   - All traffic (already set below — do not change)
# ============================================================

# Start Here
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg"  # already set — do not change
  description = "SSH access to bastion from admin IP only"
  vpc_id      = ""                                 # TODO: reference the VPC (aws_vpc.main.id)

  ingress {
    description = "SSH from admin"
    from_port   = 0   # TODO: what port number is SSH?
    to_port     = 0   # TODO: same as from_port
    protocol    = ""  # TODO: "tcp" or "udp"?
    cidr_blocks = []  # TODO: [var.admin_ip_cidr] — your IP only, not 0.0.0.0/0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # already set — do not change
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-bastion-sg"  # already set — do not change
  })
}
# End: Bastion Security Group


# ============================================================
# TODO: Private Instance Security Group
#
# Inbound:
#   - SSH (port 22) from the BASTION SECURITY GROUP only
#   - Use security_groups = [aws_security_group.bastion.id]
#   - Do NOT use cidr_blocks here — restrict by SG, not by IP range
# Outbound:
#   - All traffic (already set below — do not change)
# ============================================================

# Start Here
resource "aws_security_group" "private" {
  name        = "${var.project_name}-private-sg"  # already set — do not change
  description = "SSH access from bastion only"
  vpc_id      = ""                                 # TODO: reference the VPC (aws_vpc.main.id)

  ingress {
    description     = "SSH from bastion"
    from_port       = 0   # TODO: what port number is SSH?
    to_port         = 0   # TODO: same as from_port
    protocol        = ""  # TODO: "tcp" or "udp"?
    security_groups = []  # TODO: [aws_security_group.bastion.id] — NOT cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # already set — do not change
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-private-sg"  # already set — do not change
  })
}
# End: Private Instance Security Group


# ============================================================
# TODO: Bastion Host EC2 Instance
#
# Launch the bastion in the first public subnet with:
#   - A public IP so you can SSH in
#   - The bastion security group
#   - Your key pair
# ============================================================

# Start Here
resource "aws_instance" "bastion" {
  ami                         = ""     # TODO: var.bastion_ami_id
  instance_type               = ""     # TODO: var.bastion_instance_type
  subnet_id                   = ""     # TODO: first public subnet — aws_subnet.public[0].id
  vpc_security_group_ids      = []     # TODO: [aws_security_group.bastion.id]
  key_name                    = ""     # TODO: var.key_pair_name
  associate_public_ip_address = false  # TODO: does a bastion need a public IP? (true/false)

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-bastion"  # already set — do not change
  })
}
# End: Bastion Host
