#!/usr/bin/env bash
# =============================================================
# System Health Monitor
# Monitors CPU, memory, disk, and services. Logs with
# timestamps and alerts on threshold breaches.
# Usage: ./health-monitor.sh [-v] [-l /path/to/logfile]
# =============================================================
set -uo pipefail

# --- Configuration ---
CPU_THRESHOLD=80        # alert if CPU % exceeds this
MEM_THRESHOLD=85        # alert if memory % exceeds this
DISK_THRESHOLD=80       # alert if disk % exceeds this
LOG_DIR="$HOME/devops-portfolio/week1-bash-toolkit/logs"
LOG_FILE="$LOG_DIR/health-$(date +%Y-%m-%d).log"
SERVICES=("ssh" "cron")   # services to check (add more as needed)
VERBOSE=false

# --- Parse flags ---
while getopts "vl:h" opt; do
    case $opt in
        v) VERBOSE=true ;;
        l) LOG_FILE="$OPTARG" ;;
        h)
            echo "Usage: $0 [-v] [-l logfile]"
            echo "  -v  Verbose output"
            echo "  -l  Custom log file path"
            exit 0 ;;
        *) echo "Unknown option"; exit 1 ;;
    esac
done

# --- Setup ---
mkdir -p "$LOG_DIR"
ALERT_COUNT=0
CHECK_COUNT=0
HOSTNAME=$(hostname)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# --- Logging ---
RED='\033[0;31m'; GREEN='\033[0;32m'
YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

log() {
    local level="$1" 
    local msg="$2"
    local ts=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$ts] [$level] $msg" >> "$LOG_FILE"
    case "$level" in
        INFO)  echo -e "${GREEN}[OK]${NC}    $msg" ;;
        WARN)  echo -e "${YELLOW}[WARN]${NC}  $msg"; ((ALERT_COUNT++)) ;;
        ERROR) echo -e "${RED}[ALERT]${NC} $msg" >&2; ((ALERT_COUNT++)) ;;
        DEBUG) [[ "$VERBOSE" == true ]] && echo -e "${BLUE}[DEBUG]${NC} $msg" ;;
    esac
    ((CHECK_COUNT++))
}

# --- Cleanup on exit ---
cleanup() {
    local code=$?
    log "DEBUG" "Script exiting with code $code
    "
}
trap cleanup EXIT

# --- Header ---
echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  System Health Monitor — $HOSTNAME${NC}"
echo -e "${BLUE}  $TIMESTAMP${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# --- 1. CPU Check ---
echo -e "${BLUE}[CPU]${NC}"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | tr -d '%us,')
CPU_INT=${CPU_USAGE%.*}   # strip decimal for integer comparison

log "DEBUG" "Raw CPU usage: $CPU_USAGE%"

if [[ -n "$CPU_INT" && "$CPU_INT" -ge "$CPU_THRESHOLD" ]]; then
    log "ERROR" "CPU usage HIGH: ${CPU_USAGE}% (threshold: ${CPU_THRESHOLD}%)"
else
    log "INFO"  "CPU usage OK: ${CPU_USAGE}%"
fi

# --- 2. Memory Check ---
echo -e "\n${BLUE}[Memory]${NC}"
MEM_TOTAL=$(free | awk '/^Mem:/ {print $2}')
MEM_USED=$(free  | awk '/^Mem:/ {print $3}')

# 'awk' performs decimal calculation because in bash it is not possible, then 'printf' rounds the result to zero decimal places using the %.0f format.
MEM_PCT=$(awk "BEGIN {printf \"%.0f\", ($MEM_USED/$MEM_TOTAL)*100}")
MEM_USED_MB=$((MEM_USED / 1024))
MEM_TOTAL_MB=$((MEM_TOTAL / 1024))

if [[ "$MEM_PCT" -ge "$MEM_THRESHOLD" ]]; then
    log "ERROR" "Memory HIGH: ${MEM_PCT}% used (${MEM_USED_MB}MB / ${MEM_TOTAL_MB}MB)"
else
    log "INFO"  "Memory OK: ${MEM_PCT}% used (${MEM_USED_MB}MB / ${MEM_TOTAL_MB}MB)"
fi

# --- 3. Disk Check ---
echo -e "\n${BLUE}[Disk]${NC}"

# Internal Field Separator IFS= disable trimming at spaces, -r disable escape sequences. this code enables reading/working on the line provided by 'df -h' exactly as it is.
while IFS= read -r line; do
    MOUNT=$(echo "$line" | awk '{print $6}')
    USAGE=$(echo "$line" | awk '{print $5}' | tr -d '%')
    USED=$(echo "$line" | awk '{print $3}')
    AVAIL=$(echo "$line" | awk '{print $4}')

    if [[ "$USAGE" -ge "$DISK_THRESHOLD" ]]; then
        log "WARN"  "Disk HIGH on $MOUNT: ${USAGE}% used (${USED} used, ${AVAIL} free)"
    else
        log "INFO"  "Disk OK on $MOUNT: ${USAGE}% used (${AVAIL} free)"
    fi
done < <(df -h --output=source,size,used,avail,pcent,target -x tmpfs -x devtmpfs \
         | tail -n +2)

# --- 4. Service Checks ---
echo -e "\n${BLUE}[Services]${NC}"
for service in "${SERVICES[@]}"; do
	# Checking, Is there a running process with this name?
	# Checking, Is this service using/listening any network port?
	# Checking, Does systemd say this service is active?
    if pgrep -x "$service" &>/dev/null || \
       ss -tlnp | grep -q "$service" || \
       systemctl is-active --quiet "$service" 2>/dev/null; then
        log "INFO"  "Service running: $service"
    else
        log "WARN"  "Service not detected: $service"
    fi
done

# --- 5. Port Checks ---
echo -e "\n${BLUE}[Ports]${NC}"

# 'declare' keyword used to declare special variable (as here, it is associative array), '-A' mean Associative Array (as like dictionary)
declare -A EXPECTED_PORTS=( 
    ["22"]="SSH"
)
for port in "${!EXPECTED_PORTS[@]}"; do		# using ! with var, means calling 'key' from associative array
    service_name="${EXPECTED_PORTS[$port]}"	# here calling value from associative array of mentioned key
    if ss -tlnp | grep -q ":${port}"; then
        log "INFO"  "Port $port ($service_name) is listening"
    else
        log "WARN"  "Port $port ($service_name) not listening"
    fi
done

# --- 6. Summary ---
echo ""
echo -e "${BLUE}================================================${NC}"
if [[ $ALERT_COUNT -gt 0 ]]; then
    echo -e " ${RED}Health: DEGRADED${NC} — $ALERT_COUNT alert(s) found"
    echo -e " ${YELLOW}Review log: $LOG_FILE${NC}"
else
    echo -e " ${GREEN}Health: OK${NC} — All $CHECK_COUNT checks passed"
fi
echo -e " Log written: $LOG_FILE"
echo -e "${BLUE}================================================${NC}"
echo ""

# Exit with non-zero if any alerts were triggered
[[ $ALERT_COUNT -gt 0 ]] && exit 1 || exit 0


