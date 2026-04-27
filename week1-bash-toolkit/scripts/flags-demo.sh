#!/usr/bin/env bash
set -euo pipefail

# --- Default values ---
ENVIRONMENT="development"
VERSION=""
DRY_RUN=false
VERBOSE=false

# --- Usage function ---
usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
  -e <environment>   Target environment (development|staging|production)
  -v <version>       Application version to deploy
  -d                 Dry run — show what would happen without doing it
  -V                 Verbose output
  -h                 Show this help message

Examples:
  $0 -e staging -v 1.2.3
  $0 -e production -v 2.0.0 -d
EOF
    exit 0
}

# --- Parse flags ---
while getopts "e:v:dVh" opt; do
    case $opt in
        e) ENVIRONMENT="$OPTARG" ;;   # : means requires argument
        v) VERSION="$OPTARG"     ;;
        d) DRY_RUN=true          ;;   # no : means flag only
        V) VERBOSE=true          ;;
        h) usage                 ;;
        *) echo "Unknown option: -$OPTARG"; usage ;;
    esac
done

# --- Validate required flags ---
if [[ -z "$VERSION" ]]; then
    echo "ERROR: Version is required. Use -v <version>"
    usage
fi

# --- Use the values ---
echo "Environment: $ENVIRONMENT"
echo "Version:     $VERSION"
echo "Dry run:     $DRY_RUN"
echo "Verbose:     $VERBOSE"

if [[ "$DRY_RUN" == true ]]; then
    echo "[DRY RUN] Would deploy $VERSION to $ENVIRONMENT"
else
    echo "Deploying $VERSION to $ENVIRONMENT..."
fi


