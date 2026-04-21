# Bash DevOps Toolkit

A collection of production-focused Bash scripts built during DevOps practice.

## Scripts

| Script | Purpose | Skills Demonstrated |
|---|---|---|
| `pre-deploy-check.sh` | Pre-deployment environment validator | Functions, loops, conditionals, exit codes, argument validation |

## Usage

```bash
./scripts/pre-deploy-check.sh <environment>
# environment: development | staging | production
```

## What These Scripts Prove
- Bash scripting for real DevOps automation
- Production-safe patterns (set -euo pipefail, error handling)
- Clear user output with logging functions
- Argument validation and safety gates
