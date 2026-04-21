#!/usr/bin/env bash
set -euo pipefail

: <<COMMENT
# --- if / elif / else ---
ENVIRONMENT="production"

if [[ "$ENVIRONMENT" == "production" ]]; then
    echo "WARNING: Running in production"
elif [[ "$ENVIRONMENT" == "staging" ]]; then
    echo "Running in staging"
else
    echo "Running in development"
fi
COMMENT


: <<COMMENT
# --- Numeric comparisons ---
# -eq equal  -ne not equal  -gt greater  -lt less  -ge greater-or-equal  -le less-or-equal
FREE_DISK_GB=15

if [[ $FREE_DISK_GB -lt 5 ]]; then
    echo "ERROR: Low disk space: ${FREE_DISK_GB}GB"
elif [[ $FREE_DISK_GB -lt 10 ]]; then
    echo "WARNING: Disk space is getting low: ${FREE_DISK_GB}GB"
else
    echo "OK: Disk space is fine: ${FREE_DISK_GB}GB"
fi
COMMENT


: <<COMMENT
# --- String checks ---
USERNAME=""

if [[ -z "$USERNAME" ]]; then          # -z = is empty string
    echo "ERROR: USERNAME is not set"
fi

REQUIRED_USER="deploy"
ACTUAL_USER=$(whoami)

if [[ "$ACTUAL_USER" != "$REQUIRED_USER" ]]; then
    echo "WARNING: Expected to run as '$REQUIRED_USER', running as '$ACTUAL_USER'"
fi
COMMENT


: <<COMMENT
# --- File and directory checks ---
CONFIG_FILE="/etc/hosts"
LOG_DIR="/var/log"
MISSING_FILE="/tmp/does-not-exist"

if [[ -f "$CONFIG_FILE" ]]; then       # -f = file exists
    echo "OK: Config file found: $CONFIG_FILE"
fi

if [[ -d "$LOG_DIR" ]]; then           # -d = directory exists
    echo "OK: Log directory exists: $LOG_DIR"
fi

if [[ ! -f "$MISSING_FILE" ]]; then    # ! negates
    echo "ERROR: Required file missing: $MISSING_FILE"
fi
COMMENT


: <<COMMENT
# --- Check if command exists (used in setup scripts) ---
if command -v docker &>/dev/null; then
    echo "OK: Docker is installed"
else
    echo "WARNING: Docker not found"
fi
COMMENT


: <<COMMENT
# In your scripts, exit with meaningful codes
check_disk() {
    local free_gb=$1
    if [[ $free_gb -lt 5 ]]; then
        echo "ERROR: Insufficient disk space"
        exit 1    # failure
    fi
    echo "OK: Disk space sufficient"
    # implicit exit 0 = success
}

check_disk 3    # triggers exit 1
COMMENT


