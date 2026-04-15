# Cloud Engineer Project

A structured, hands-on repository for anyone looking to bridge the gap between Cloud Support Technician and Cloud Engineer — built around real-world tasks that Senior Cloud Engineers perform daily.

## Who This Is For

- Cloud Support Technicians leveling up to Cloud Engineer
- Anyone preparing for AWS certifications and wanting practical experience
- Engineers who want to sharpen skills across infrastructure-as-code tooling

## How It Works

Each project is built around a **Problem Statement** — a realistic scenario you might encounter on the job. You then solve it using all four methods:

| Method | Description |
|---|---|
| **AWS CLI** | Command-line driven automation using the AWS CLI |
| **Terraform** | Infrastructure as Code using HashiCorp Terraform |
| **CloudFormation** | AWS-native IaC using CloudFormation templates |
| **AWS Console** | Manual walkthrough via the AWS Management Console |

Working through all four methods for the same problem builds deep understanding of *what* AWS is doing — not just *how* a tool works.

## Repository Structure

```
cloud_engineer/
├── docs/                        # Role definitions, project catalog, guides
├── projects/                    # All projects live here
│   └── 01-foundational-vpc/     # Project folders follow this pattern
│       ├── PROBLEM_STATEMENT.md
│       ├── aws-cli/
│       ├── terraform/
│       ├── cloudformation/
│       └── console/
└── templates/                   # Reusable project scaffold
```

## Projects

| # | Project | Skills Covered |
|---|---|---|
| 01 | [Foundational VPC Network](./projects/01-foundational-vpc/PROBLEM_STATEMENT.md) | Networking, Subnets, IGW, NAT, Routing, Security Groups |

More projects coming. See [docs/project-ideas.md](./docs/project-ideas.md) for the full roadmap.

## Cost Philosophy

Every project is designed to be **torn down and rebuilt**. Resources are provisioned with cleanup scripts or teardown instructions so you only pay while actively learning. Estimated costs are noted in each project's problem statement.

## Community

This project is growing into a community resource. A website and Discord are planned. Contributions, suggestions, and improvements are welcome — see [CONTRIBUTING.md](./CONTRIBUTING.md).
