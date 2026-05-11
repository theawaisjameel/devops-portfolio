# Bash DevOps Toolkit

Production-focused Bash automation scripts demonstrating real DevOps engineering practices, argument handling, error trapping, structured logging, and automated scheduling.

## Scripts

| Script | Purpose |
|---|---|
| `pre-deploy-check.sh` | Validates environment before deployment |
| `health-monitor.sh` | Monitors CPU, memory, disk, services |

## Skills Demonstrated

- Bash scripting with `set -euo pipefail` safety flags
- Flag parsing with `getopts`
- Error trapping and cleanup with `trap`
- Structured logging with timestamps and log levels
- System metrics parsing with `awk`
- Automated scheduling via `cron`
- Exit code-based pass/fail reporting

## Usage

**Pre-deployment checker:**
```bash
./scripts/pre-deploy-check.sh -e production -v 1.2.3
# environment: development | staging | production
```

**Health monitor (manual run):**
```bash
./scripts/health-monitor.sh -v
```

**Health monitor (automated every 5 min via cron):**
```bash
*/5 * * * * /path/to/health-monitor.sh
```

## What This Proves to Employers
These projects demonstrates my ability to write production-safe automation scripts following real DevOps patterns, the same scripts that run on servers in real environments.
