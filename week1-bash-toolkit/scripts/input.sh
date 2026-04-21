#!/usr/bin/env bash
set -euo pipefail


# --- Validate arguments ---
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <environment> <version>"
    echo "Example: $0 production 1.2.3"
    exit 1
fi


ENVIRONMENT="$1"
VERSION="$2"


# Validate environment value
valid_envs=("development" "staging" "production")
valid=false
for env in "${valid_envs[@]}"; do
    if [[ "$ENVIRONMENT" == "$env" ]]; then
        valid=true
        break
    fi
done


if [[ "$valid" == false ]]; then
    echo "ERROR: Invalid environment '$ENVIRONMENT'"
    echo "Valid options: ${valid_envs[*]}"
    exit 1
fi


echo "Deploying version $VERSION to $ENVIRONMENT"


# --- Interactive input ---
read -p "Are you sure? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    echo "Aborted."
    exit 0
fi


echo "Proceeding with deployment..."


