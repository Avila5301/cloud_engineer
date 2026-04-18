# Cloud Engineer Project

A structured, hands-on repository for anyone looking to bridge the gap between Cloud Support Technician and Cloud Engineer — built around real-world tasks that Senior Cloud Engineers perform daily.

## Who This Is For

- Cloud Support Technicians leveling up to Cloud Engineer
- Anyone preparing for AWS certifications and wanting practical experience
- Engineers who want to sharpen skills across infrastructure-as-code tooling

## How It Works

Each project is built around a **Problem Statement** — a realistic scenario you might encounter on the job. You then work through it using all four methods:

| Method | Description |
|---|---|
| **AWS CLI** | Command-line driven automation using the AWS CLI |
| **Terraform** | Infrastructure as Code using HashiCorp Terraform |
| **CloudFormation** | AWS-native IaC using CloudFormation templates |
| **AWS Console** | Manual walkthrough via the AWS Management Console |

Working through all four methods for the same problem builds deep understanding of *what* AWS is doing — not just *how* a tool works.

## Three-Stage Learning Flow

Every implementation method follows the same pattern:

```
Stage 1: Exercise     → Complete a skeleton/partial version yourself
Stage 2: Troubleshoot → Find and fix intentional errors in a broken version
Stage 3: Solution     → Deploy the working version, use it for future projects
```

This structure ensures you build and debug before you deploy — which is how real engineering works.

## Repository Structure

```
aws-cloud-engineer/
├── docs/                          # Role definitions, project catalog, guides
├── projects/                      # All projects live here
│   └── 01-foundational-vpc/       # Each project follows this pattern
│       ├── PROBLEM_STATEMENT.md
│       ├── aws-cli/
│       │   ├── exercise/          # Skeleton script to complete
│       │   ├── troubleshoot/      # Broken script with intentional errors
│       │   └── solution/          # Working deploy + teardown scripts
│       ├── terraform/
│       │   ├── exercise/
│       │   ├── troubleshoot/
│       │   └── solution/
│       ├── cloudformation/
│       │   ├── exercise/
│       │   ├── troubleshoot/
│       │   └── solution/
│       └── console/               # Step-by-step console walkthrough
├── portfolio/                     # Your personal workspace for completed work
└── templates/                     # Reusable project scaffold
```

## Projects

| # | Project | Skills Covered |
|---|---|---|
| 01 | [Foundational VPC Network](./projects/01-foundational-vpc/PROBLEM_STATEMENT.md) | Networking, Subnets, IGW, NAT, Routing, Security Groups |

More projects are on the way. See [docs/project-ideas.md](./docs/project-ideas.md) for the full roadmap covering 38 projects across 8 tracks.

## Cost Philosophy

Every project is designed to be **torn down and rebuilt**. Resources are provisioned with cleanup scripts or teardown instructions so you only pay while actively learning. Estimated costs are noted in each project's problem statement.

> **Note:** As of February 2024, AWS charges $0.005/hr for all public IPv4 addresses — whether attached or not. Factor this into your session planning.

## Fork It, Share It, Grow It

This project is built to be a community resource. If it's been useful to you:

- **Fork the repo** and work through it at your own pace
- **Share it** with teammates, study groups, or anyone making the jump from support to engineering
- **Open a PR** to add a new project, fix an error, or improve an existing walkthrough
- **Suggest ideas** by opening an issue — more project ideas and community input are always welcome

The goal is to make this the go-to hands-on learning path for Cloud Engineers at any level. A community website and Discord are planned as this grows.

See [CONTRIBUTING.md](./CONTRIBUTING.md) for how to add projects and contribute improvements.

## Reference Docs

- [Senior Cloud Engineer Role Definition](./docs/senior-cloud-engineer-role.md)
- [Project Roadmap](./docs/project-ideas.md)
- [Contributing Guide](./CONTRIBUTING.md)
