# Project Ideas & Roadmap

Projects are ordered to build on each other. Start from the top — each project assumes the skills from the ones before it.

---

## Track 1 — Networking Foundations

| # | Project | Skills |
|---|---|---|
| 01 | Foundational VPC Network | VPC, Subnets, IGW, NAT Gateway, Route Tables, Security Groups, NACLs, Bastion Host |
| 02 | VPC Peering & Transit Gateway | Multi-VPC connectivity, hub-and-spoke routing, cross-account peering |
| 03 | Site-to-Site VPN | Virtual Private Gateway, Customer Gateway, IPSec tunnels |
| 04 | Route 53 Private Hosted Zones | DNS within VPCs, split-horizon DNS, resolver endpoints |

---

## Track 2 — Compute & OS Administration

| # | Project | Skills |
|---|---|---|
| 05 | EC2 Fleet with Auto Scaling | Launch Templates, ASG, ALB, target tracking, lifecycle hooks |
| 06 | Linux Server Hardening | CIS benchmarks, SSH key management, sudoers, auditd, fail2ban |
| 07 | Windows Server in AWS | EC2 Windows, Active Directory (AWS Managed AD), RDP over SSM |
| 08 | Systems Manager at Scale | Patch Manager, Session Manager, Run Command, State Manager |
| 09 | Custom AMI Pipeline | EC2 Image Builder, Packer, golden image strategy |

---

## Track 3 — Storage

| # | Project | Skills |
|---|---|---|
| 10 | S3 as a Shared Drive | S3 + s3fs or mountpoint-s3, IAM policies, bucket policies, versioning |
| 11 | EFS — Elastic File System | NFS shared storage, mount targets, access points, lifecycle policies |
| 12 | FSx for Windows File Server | SMB shares, Active Directory integration, DFS namespaces |
| 13 | FSx for Lustre | HPC workloads, S3 data repository integration |

---

## Track 4 — Databases

| # | Project | Skills |
|---|---|---|
| 14 | RDS MySQL — Provisioning & Operations | Multi-AZ, read replicas, parameter groups, snapshots, restore |
| 15 | RDS PostgreSQL — Provisioning & Operations | Same as above with Postgres-specific tooling |
| 16 | Aurora Serverless v2 | Autoscaling capacity, cluster endpoints, global database |
| 17 | DynamoDB | Table design, GSI/LSI, capacity modes, DynamoDB Streams |
| 18 | ElastiCache (Redis) | Session caching, cluster mode, replication groups |
| 19 | Database Migration Service (DMS) | Migrate on-prem DB to RDS, CDC replication |

---

## Track 5 — CI/CD & Infrastructure Pipelines

| # | Project | Skills |
|---|---|---|
| 20 | GitHub Actions → S3 Deployment | OIDC auth (no long-lived keys), S3 sync, CloudFront invalidation |
| 21 | GitHub Actions → Terraform | terraform plan/apply in CI, remote state, PR comments |
| 22 | GitHub Actions → CloudFormation | cfn-lint, change sets, staged deployments |
| 23 | CodePipeline Full Stack | Source, Build, Test, Deploy stages using AWS-native tooling |
| 24 | Self-hosted GitHub Actions Runner on EC2 | Runner lifecycle, IAM role for runner, auto-scaling runners |

---

## Track 6 — Security & Compliance

| # | Project | Skills |
|---|---|---|
| 25 | IAM Least Privilege Audit | IAM Access Analyzer, unused permissions, permission boundaries |
| 26 | Secrets Manager & Parameter Store | Secret rotation, Lambda rotation function, SSM SecureString |
| 27 | AWS Config + Security Hub | Config rules, conformance packs, Security Hub standards |
| 28 | GuardDuty + Automated Remediation | Threat findings, EventBridge rules, Lambda auto-remediation |
| 29 | AWS Organizations & SCPs | Multi-account strategy, preventive guardrails, OU structure |

---

## Track 7 — Monitoring & Observability

| # | Project | Skills |
|---|---|---|
| 30 | CloudWatch Dashboards & Alarms | Custom metrics, composite alarms, anomaly detection |
| 31 | Centralized Logging with OpenSearch | CloudWatch Logs subscription filters, Lambda shipper, Kibana |
| 32 | X-Ray Distributed Tracing | Service map, trace sampling, Lambda and ECS integration |
| 33 | Cost Explorer & Budgets | Cost allocation tags, budget alerts, Savings Plans analysis |

---

## Track 8 — Enterprise Stack (Capstone)

These projects combine everything above into a realistic multi-tier enterprise application stack.

| # | Project | Skills |
|---|---|---|
| 34 | Three-Tier Web App | VPC + ALB + EC2 ASG + RDS Multi-AZ + ElastiCache |
| 35 | Containerized App on ECS Fargate | ECR, ECS task definitions, service discovery, ALB + HTTPS |
| 36 | Serverless API | API Gateway + Lambda + DynamoDB + Cognito auth |
| 37 | Full CI/CD for the Enterprise Stack | GitOps flow, environment promotion (dev → staging → prod) |
| 38 | Disaster Recovery Runbook | RTO/RPO planning, cross-region replication, failover testing |

---

## Notes

- Projects will be added to the `projects/` folder as they are built out
- Each project folder contains all four implementation methods
- All projects include estimated AWS costs and teardown instructions
- Difficulty increases within each track but tracks can be worked in parallel
