# Project 01 — AWS CLI Implementation

## Learning Flow

Work through the three stages in order. Do not skip ahead to the solution.

```
Stage 1: Exercise    → Build a partial version yourself
Stage 2: Troubleshoot → Find and fix 5 errors in a broken script
Stage 3: Solution    → Deploy the working version, keep it for future projects
```

---

## Stage 1 — Exercise: Build It

**Folder:** `exercise/`

You are given a skeleton deploy script with key sections intentionally left blank. Your job is to fill in the missing pieces using the AWS CLI documentation and what you know about VPC networking.

The exercise README will guide you through what each blank expects. Do not look at the solution folder until you've made a genuine attempt.

[Go to Exercise →](./exercise/README.md)

---

## Stage 2 — Troubleshoot: Fix It

**Folder:** `troubleshoot/`

You are given a complete-looking deploy script that has **5 intentional errors** embedded in it. Some are syntax errors. Some are logical errors that will either cause the deployment to fail outright or produce a broken network silently.

Your job: find and fix all 5 errors without running the script first. Read it carefully.

[Go to Troubleshoot →](./troubleshoot/README.md)

---

## Stage 3 — Solution: Deploy It

**Folder:** `solution/`

The complete, working deploy and teardown scripts. Once you have finished the exercise and troubleshoot stages, use these to perform the actual deployment.

The solution scripts are also what subsequent projects will reference when they need this VPC to exist.

[Go to Solution →](./solution/)

---

## Prerequisites (all stages)

- AWS CLI v2 installed and configured (`aws configure`)
- An EC2 key pair already created in your target region
- `jq` installed (`sudo apt-get install jq` or `brew install jq`)
- Your public IP: `curl https://checkip.amazonaws.com`
