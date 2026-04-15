variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Short name prefix applied to all resource names and tags"
  type        = string
  default     = "cloud-engineer-01"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of AZs to spread subnets across (must match the region)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "admin_ip_cidr" {
  description = "Your public IP in CIDR notation (e.g. 203.0.113.10/32) — restricts bastion SSH access"
  type        = string
}

variable "key_pair_name" {
  description = "Name of an existing EC2 key pair in the target region"
  type        = string
}

variable "bastion_ami_id" {
  description = "AMI ID for the bastion host (Amazon Linux 2 recommended)"
  type        = string
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2 us-east-1 — update for other regions
}

variable "bastion_instance_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "common_tags" {
  description = "Tags applied to every resource"
  type        = map(string)
  default = {
    Project     = "cloud-engineer-01"
    ManagedBy   = "terraform"
    Environment = "learning"
  }
}
