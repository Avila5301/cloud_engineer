# Project 01 — Foundational VPC Network

## Problem Statement

Your company is launching a new application environment on AWS. Before any servers, databases, or services can be deployed, the networking foundation must be in place. You have been asked to build a production-grade VPC that follows AWS best practices: public-facing resources in public subnets, application and database tiers in private subnets, redundancy across two Availability Zones, and controlled outbound internet access from private resources.

This VPC will become the foundation for every subsequent project in this series.

## Business Context

Nearly every AWS architecture failure that involves "the internet could reach our database" or "we lost access to our instances" traces back to a poorly designed VPC. Getting this right from the start determines whether the infrastructure you build on top of it is secure and resilient — or fragile and exposed.

A Senior Cloud Engineer is expected to design and provision this from memory. By the end of this project, so will you.

## What You Will Build

- 1 VPC (`10.0.0.0/16`)
- 2 Public Subnets across 2 Availability Zones
- 2 Private Subnets across 2 Availability Zones
- 1 Internet Gateway (attached to the VPC)
- 1 NAT Gateway (in Public Subnet 1, with an Elastic IP)
- 1 Public Route Table (routes `0.0.0.0/0` → IGW)
- 1 Private Route Table (routes `0.0.0.0/0` → NAT Gateway)
- 1 Bastion Host Security Group (allows SSH inbound from your IP only)
- 1 Private Instance Security Group (allows SSH inbound from Bastion SG only)
- 1 Bastion Host EC2 instance (t3.micro in Public Subnet 1) for connectivity validation

## Architecture

```
                         Internet
                            |
                    [Internet Gateway]
                            |
          ┌─────────────────┴──────────────────┐
          │               VPC                  │
          │           10.0.0.0/16              │
          │                                    │
          │  ┌──────────────┐ ┌─────────────┐  │
          │  │ Public Sub 1 │ │ Public Sub 2│  │
          │  │ 10.0.1.0/24  │ │ 10.0.2.0/24│  │
          │  │  us-east-1a  │ │ us-east-1b │  │
          │  │              │ │             │  │
          │  │ [Bastion EC2]│ │             │  │
          │  │ [NAT Gateway]│ │             │  │
          │  └──────┬───────┘ └─────────────┘  │
          │         │ (NAT)                     │
          │  ┌──────┴───────┐ ┌─────────────┐  │
          │  │ Private Sub 1│ │ Private Sub2│  │
          │  │ 10.0.10.0/24 │ │10.0.20.0/24│  │
          │  │  us-east-1a  │ │ us-east-1b │  │
          │  └──────────────┘ └─────────────┘  │
          └────────────────────────────────────┘
```

## Success Criteria

- [ ] VPC exists with CIDR `10.0.0.0/16`
- [ ] 4 subnets exist across 2 AZs (2 public, 2 private)
- [ ] Public subnets have `Auto-assign public IPv4` enabled
- [ ] Internet Gateway is attached to the VPC
- [ ] Public route table routes `0.0.0.0/0` to the IGW
- [ ] NAT Gateway exists in a public subnet with an Elastic IP
- [ ] Private route table routes `0.0.0.0/0` to the NAT Gateway
- [ ] Bastion host is reachable via SSH from your IP
- [ ] From the bastion host, you can reach the internet (e.g., `curl https://checkip.amazonaws.com`)
- [ ] Private instances are NOT directly reachable from the internet

## Estimated AWS Cost

| Resource | Rate | Cost for 2hr session |
|---|---|---|
| NAT Gateway | $0.045/hr + data | ~$0.09 |
| Elastic IP (attached) | Free while attached | $0.00 |
| EC2 t3.micro (bastion) | ~$0.0104/hr | ~$0.02 |
| VPC, subnets, IGW, routes | Free | $0.00 |
| **Estimated total** | | **~$0.11** |

> The NAT Gateway is the only meaningful cost driver. Tear it down when done.

## Prerequisites

- AWS account with admin or power-user permissions
- AWS CLI v2 configured (`aws configure`)
- An EC2 key pair created in your target region
- Terraform >= 1.5 (for the Terraform method)
- Basic familiarity with AWS networking concepts

## Implementation Methods

| Method | Folder | Estimated Time |
|---|---|---|
| AWS Console | [console/](./console/) | ~30 min |
| AWS CLI | [aws-cli/](./aws-cli/) | ~20 min |
| Terraform | [terraform/](./terraform/) | ~20 min |
| CloudFormation | [cloudformation/](./cloudformation/) | ~20 min |

## Key Concepts

- **VPC (Virtual Private Cloud)** — An isolated network within AWS. Everything you build lives inside a VPC.
- **Subnet** — A range of IP addresses within a VPC, scoped to a single AZ. Public subnets have a route to the IGW; private subnets do not.
- **Internet Gateway (IGW)** — Allows resources in public subnets to communicate with the internet.
- **NAT Gateway** — Allows resources in private subnets to initiate outbound internet connections (e.g., to download updates) without being reachable from the internet.
- **Route Table** — Controls where network traffic is directed. Each subnet is associated with one route table.
- **Security Group** — A stateful virtual firewall attached to an EC2 instance or other resource.
- **NACL (Network ACL)** — A stateless firewall applied at the subnet level. Less commonly modified than Security Groups but important to understand.
- **Bastion Host** — A hardened EC2 instance in a public subnet used as a secure jump point into private subnet resources.

## What's Next

After completing this project, proceed to [Project 02 — VPC Peering & Transit Gateway](../02-vpc-peering/PROBLEM_STATEMENT.md) to connect multiple VPCs together.
