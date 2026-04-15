# Contributing

Contributions are welcome and encouraged. This project is meant to grow into a community resource.

## Ways to Contribute

- **Add a new project** — Follow the project template and submit a PR
- **Improve an existing project** — Fix errors, add clarity, improve scripts
- **Add a new implementation method** — If a project is missing a CLI or Terraform solution, add it
- **Report issues** — Open an issue if something is broken, unclear, or outdated

## Adding a New Project

1. Copy the `templates/project-template/` folder into `projects/`
2. Name it with the next sequential number and a short slug: `02-project-name/`
3. Fill out `PROBLEM_STATEMENT.md` completely
4. Implement at least one of the four methods (CLI, Terraform, CloudFormation, Console)
5. Include teardown instructions for any method that provisions real AWS resources
6. Submit a pull request with a short description of what the project teaches

## Project Standards

- **Problem Statements** must describe a realistic, job-relevant scenario
- **Scripts and templates** must be tested and working
- **Teardown** instructions are required for any provisioned resources
- **Costs** should be estimated and noted in the problem statement
- **No hardcoded credentials** — use environment variables, IAM roles, or parameter files

## Code Style

- Terraform: Use `terraform fmt` before committing
- Shell scripts: Use `#!/bin/bash` and `set -euo pipefail`
- CloudFormation: YAML preferred over JSON
- Comment your code where the intent isn't obvious

## Commit Messages

Use short, descriptive commit messages:
```
add: project 02 - S3 static website with CloudFront
fix: terraform destroy order in project 01
update: clarify NAT Gateway teardown steps
```
