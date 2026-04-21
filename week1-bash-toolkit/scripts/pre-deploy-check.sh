#!/usr/bin/env bash
# =============================================================
# Pre-Deployment Environment Checker
# Usage: ./pre-deploy-check.sh <environment>
# =============================================================
set -uo pipefail   # Note: no -e here, we handle errors manually


# --- Colors and logging ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log_info()  { echo -e "${GREEN}[PASS]${NC}  $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error() { echo -e "${RED}[FAIL]${NC}  $1"; }
log_title() { echo -e "\n${BLUE}=== $1 ===${NC}"; }


# --- Track overall result ---
CHECKS_PASSED=0
CHECKS_FAILED=0

pass() { log_info "$1";  ((CHECKS_PASSED++)); }
fail() { log_error "$1"; ((CHECKS_FAILED++)); }


# --- Argument check ---
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <environment>"
    echo "Example: $0 production"
    exit 1
fi


ENVIRONMENT="$1"
DEPLOY_USER="$(whoami)"
MIN_DISK_GB=5
REQUIRED_CMDS=("git" "curl" "python3")

echo -e "${BLUE}Pre-Deployment Check — Environment: ${ENVIRONMENT}${NC}"
echo "Running as: $DEPLOY_USER  |  Date: $(date)"


# --- Check 1: Environment validity ---
log_title "Environment Validation"
if [[ "$ENVIRONMENT" =~ ^(development|staging|production)$ ]]; then
    pass "Environment '$ENVIRONMENT' is valid"
else
    fail "Unknown environment: '$ENVIRONMENT'"
fi


# --- Check 2: Required commands available ---
log_title "Required Tools"
for cmd in "${REQUIRED_CMDS[@]}"; do
    if command -v "$cmd" &>/dev/null; then
        pass "Command available: $cmd ($(command -v $cmd))"
    else
        fail "Command not found: $cmd"
    fi
done


# --- Check 3: Disk space ---
log_title "Disk Space"
AVAILABLE_KB=$(df / | awk 'NR==2 {print $4}')
AVAILABLE_GB=$((AVAILABLE_KB / 1024 / 1024))

if [[ $AVAILABLE_GB -ge $MIN_DISK_GB ]]; then
    pass "Disk space OK: ${AVAILABLE_GB}GB available (min: ${MIN_DISK_GB}GB)"
else
    fail "Insufficient disk: ${AVAILABLE_GB}GB available (min: ${MIN_DISK_GB}GB)"
fi


# --- Check 4: Required files/dirs ---
log_title "File System Checks"
REQUIRED_PATHS=("/etc/hosts" "/tmp" "$HOME")

for path in "${REQUIRED_PATHS[@]}"; do
    if [[ -e "$path" ]]; then
        pass "Path exists: $path"
    else
        fail "Required path missing: $path"
    fi
done


# --- Check 5: Network connectivity ---
log_title "Network Connectivity"
if ping -c 1 -W 3 8.8.8.8 &>/dev/null; then
    pass "Internet connectivity OK"
else
    fail "No internet connectivity"
fi

if curl -sf --max-time 5 https://github.com &>/dev/null; then
    pass "GitHub reachable"
else
    fail "Cannot reach GitHub"
fi


# --- Check 6: Production safety gate ---
log_title "Safety Checks"
if [[ "$ENVIRONMENT" == "production" ]]; then
    log_warn "Production deployment — extra checks enabled"
    read -p "  Type 'DEPLOY' to confirm production release: " CONFIRM
    if [[ "$CONFIRM" == "DEPLOY" ]]; then
        pass "Production deployment confirmed by $DEPLOY_USER"
    else
        fail "Production confirmation failed — deployment aborted"
    fi
else
	log_warn "Skipping production safety checks for '${ENVIRONMENT}'"
fi


# --- Summary ---
TOTAL=$((CHECKS_PASSED + CHECKS_FAILED))
echo ""
echo "================================================"
echo -e " Results: ${GREEN}${CHECKS_PASSED} passed${NC} / ${RED}${CHECKS_FAILED} failed${NC} / ${TOTAL} total"
echo "================================================"

if [[ $CHECKS_FAILED -gt 0 ]]; then
    echo -e "${RED}Pre-deployment checks FAILED. Do not deploy.${NC}"
    exit 1
else
    echo -e "${GREEN}All checks passed. Safe to deploy.${NC}"
    exit 0
fi


