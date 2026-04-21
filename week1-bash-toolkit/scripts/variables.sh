#!/usr/bin/env bash
set -euo pipefail

# --- Variable types ---

# Regular variable (no spaces around =, ever)
APP_NAME="myapp"
VERSION="1.0.0"
PORT=8080

# Read-only (like a constant)
readonly MAX_RETRIES=3

# Environment variable (exported to child processes)
export DB_HOST="localhost"

# Command substitution — store command output in a variable
CURRENT_USER=$(whoami)
CURRENT_DATE=$(date +%Y-%m-%d)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')

echo "App:    $APP_NAME v$VERSION"
echo "Port:   $PORT"
echo "User:   $CURRENT_USER"
echo "Date:   $CURRENT_DATE"
echo "Disk:   $DISK_USAGE used"

# --- Special variables ---
echo "Script name:     $0"
echo "First argument:  $1"      # will be empty if not provided
echo "Second argument: $2"
echo "All arguments (seperately):   $@"
echo "All arguments (as one string):   $*"
echo "Argument count:  $#"
echo "Current PID:     $$"
echo "Last exit code:  $?"      # 0 = success, non-zero = failure


