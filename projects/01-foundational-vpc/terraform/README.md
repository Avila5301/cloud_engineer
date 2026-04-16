# Project 01 — Terraform Implementation

## Learning Flow

```
Stage 1: Exercise    → Complete a partial main.tf
Stage 2: Troubleshoot → Find and fix 5 errors in a broken configuration
Stage 3: Solution    → Deploy the working configuration
```

---

## Stage 1 — Exercise: Build It

**Folder:** `exercise/`

Complete `main.tf` by filling in all `# TODO` blocks. Variables and outputs are provided for you. You only need to write the resource blocks in `main.tf`.

[Go to Exercise →](./exercise/README.md)

---

## Stage 2 — Troubleshoot: Fix It

**Folder:** `troubleshoot/`

A complete Terraform configuration with **5 intentional errors**. Some errors will cause `terraform apply` to fail. Others will apply successfully but produce broken or insecure infrastructure.

Find and fix all 5 by reading the code — not by running it.

[Go to Troubleshoot →](./troubleshoot/README.md)

---

## Stage 3 — Solution: Deploy It

**Folder:** `solution/`

The complete, working Terraform configuration. Use this for actual deployment.

```bash
cd solution/
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

Teardown:
```bash
terraform destroy
```

[Go to Solution →](./solution/)
