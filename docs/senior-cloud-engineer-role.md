# Senior Cloud Engineer — Role Definition

## What the Role Actually Is

A Senior Cloud Engineer designs, builds, and maintains cloud infrastructure at scale. They are the bridge between raw AWS services and working production systems — translating business requirements into reliable, secure, and cost-effective infrastructure. They also mentor junior engineers and set the standards that the team operates by.

This is different from a Cloud Support Technician, who primarily responds to issues within existing infrastructure. A Senior Cloud Engineer *creates* and *owns* the infrastructure.

---

## Core Responsibilities

### Infrastructure Design & Provisioning
- Design VPC architectures (multi-AZ, multi-region, hub-and-spoke)
- Provision compute (EC2, ECS, EKS, Lambda) based on workload requirements
- Design and manage storage solutions (S3, EFS, FSx, EBS)
- Set up and maintain RDS, Aurora, DynamoDB, and other managed database services
- Plan and implement disaster recovery and high availability architectures

### Infrastructure as Code (IaC)
- Write and maintain Terraform modules used across multiple teams/projects
- Build and manage CloudFormation stacks and StackSets
- Version-control all infrastructure — nothing is manually provisioned without a corresponding IaC definition
- Review and approve IaC pull requests from other engineers

### CI/CD & Automation
- Design and maintain CI/CD pipelines (GitHub Actions, CodePipeline, Jenkins)
- Automate infrastructure deployments, rollbacks, and environment promotions
- Build tooling to reduce toil — scripts, Lambda functions, internal CLIs
- Integrate IaC pipelines with approval gates and drift detection

### Security & Compliance
- Implement least-privilege IAM policies and roles
- Manage secrets using Secrets Manager and Parameter Store
- Enforce security controls via SCPs, Config Rules, and GuardDuty
- Conduct security reviews of new infrastructure before production release
- Ensure compliance with standards (SOC2, HIPAA, PCI) when applicable

### Networking
- Design and manage complex VPC topologies
- Configure VPN, Direct Connect, Transit Gateway, and VPC Peering
- Manage DNS via Route 53 (including private hosted zones)
- Implement WAF, Shield, and Network Firewall rules
- Troubleshoot deep networking issues (routing, MTU, asymmetric flows)

### Cost Management
- Tag all resources and enforce tagging policies
- Analyze Cost Explorer and Trusted Advisor reports
- Right-size instances and identify waste (idle resources, oversized RDS, orphaned EBS)
- Design architectures that balance performance with cost (spot instances, reserved capacity)
- Report on monthly spend and forecast future costs

### Monitoring & Observability
- Set up CloudWatch dashboards, alarms, and metric filters
- Implement centralized logging (CloudWatch Logs, OpenSearch, third-party)
- Configure distributed tracing (X-Ray, Datadog APM)
- Define SLOs and build alerting around them
- Lead incident response and post-mortem processes

### OS & Systems Administration
- Manage Linux fleets (patching, hardening, user management, systemd services)
- Manage Windows Server environments (AD, GPO, IIS, PowerShell automation)
- Use Systems Manager for patch management, session access, and run commands at scale
- Build and maintain AMIs and EC2 Image Builder pipelines

### Mentorship & Standards
- Define team standards for IaC, naming conventions, and architecture patterns
- Review infrastructure designs proposed by junior engineers
- Write runbooks and documentation that others can actually follow
- Lead architecture decision records (ADRs) for significant changes

---

## Skills That Separate Good from Great

| Skill | Why It Matters |
|---|---|
| Deep networking knowledge | Most production outages have a networking root cause |
| IaC at scale (modules, workspaces) | Copy-paste Terraform doesn't scale past 3 engineers |
| Cost optimization intuition | Infrastructure spend is always under a microscope |
| Security-first thinking | A single misconfigured S3 bucket can end a company |
| Scripting (Bash, Python) | AWS CLI alone isn't enough — you need glue code |
| Reading and writing documentation | Senior engineers communicate decisions clearly |

---

## How This Project Maps to the Role

Each project in this repo is chosen to target a specific area of the senior role. By the time you've worked through the full catalog, you will have hands-on experience with:

- Networking architecture from scratch
- IaC across multiple toolchains
- CI/CD pipelines pushing real infrastructure changes
- OS-level administration on both Linux and Windows
- Database provisioning and common DBA tasks
- Cost-aware, teardown-friendly infrastructure design

That is the gap between Cloud Support Technician and Cloud Engineer — and this repo is how you close it.
