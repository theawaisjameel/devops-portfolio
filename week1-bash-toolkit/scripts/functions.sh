#!/usr/bin/env bash
set -euo pipefail


# --- Logging functions (use these in every real script) ---
# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'    # No Color (reset)

log_info()    { echo -e "${GREEN}[INFO]${NC}  $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }  # errors go to stderr


# --- Functions with arguments ---
check_service() {
    local service_name="$1"       # local = scoped to function only
    local port="$2"
    
    if ss -tlnp | grep -q ":${port}"; then
        log_info "$service_name is running on port $port"
        return 0    # success
    else
        log_warn "$service_name is NOT running on port $port"
        return 1    # failure
    fi
}


check_disk_space() {
    local path="${1:-/}"          # default to / if no argument given
    local threshold="${2:-80}"    # default 80% threshold
    
    local usage
    usage=$(df "$path" | awk 'NR==2 {print $5}' | tr -d '%')
    
    if [[ $usage -gt $threshold ]]; then
        log_error "Disk usage is ${usage}% on $path (threshold: ${threshold}%)"
        return 1
    fi
    log_info "Disk usage is ${usage}% on $path"
    return 0
}


create_deploy_dir() {
    local dir="$1"
    local owner="${2:-$USER}"
    
    if [[ -d "$dir" ]]; then
        log_warn "Directory already exists: $dir"
        return 0
    fi
    
    mkdir -p "$dir"
    chown "$owner" "$dir"
    log_info "Created directory: $dir (owner: $owner)"
}


# --- Call the functions ---
log_info "Starting pre-deployment checks"

check_service "SSH"   "22"   || true   # || true prevents exit on failure
check_service "HTTP"  "80"   || true
check_service "Flask" "8080" || true

check_disk_space "/"          # uses default 80% threshold
check_disk_space "/" "95"     # custom threshold

create_deploy_dir "/tmp/test-deploy" "$USER"

log_info "All checks complete"


