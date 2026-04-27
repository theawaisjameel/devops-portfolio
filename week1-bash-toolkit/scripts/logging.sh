LOG_FILE="${LOG_FILE:-/tmp/script.log}"
LOG_LEVEL="${LOG_LEVEL:-INFO}"    # INFO, WARN, ERROR

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'
YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

_log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local line="[$timestamp] [$level] $message"

    # Write to log file (no colors)
    echo "$line" >> "$LOG_FILE"

    # Print to terminal (with colors)
    case "$level" in
        INFO)  echo -e "${GREEN}[INFO]${NC}  $timestamp — $message" ;;
        WARN)  echo -e "${YELLOW}[WARN]${NC}  $timestamp — $message" ;;
        ERROR) echo -e "${RED}[ERROR]${NC} $timestamp — $message" >&2 ;;
        DEBUG) [[ "${VERBOSE:-false}" == true ]] && \
               echo -e "${BLUE}[DEBUG]${NC} $timestamp — $message" ;;
    esac
}

log_info()  { _log "INFO"  "$1"; }
log_warn()  { _log "WARN"  "$1"; }
log_error() { _log "ERROR" "$1"; }
log_debug() { _log "DEBUG" "$1"; }


