#!/usr/bin/env bash
set -euo pipefail


: <<'COMMENT'
# --- for loop ---
SERVERS=("web-01" "web-02" "web-03" "db-01")

echo "=== Checking servers ==="
for server in "${SERVERS[@]}"; do
    echo "Pinging $server..."
    # In real life: ssh $server 'uptime'
done
COMMENT


: <<'COMMENT'
# --- for loop over range ---
echo "=== Retry loop ==="
for i in {1..5}; do
    echo "Attempt $i of 5"
done
COMMENT


: <<'COMMENT'
# --- for loop over files ---
echo "=== Config files in /etc ==="
for config in /etc/*.conf; do
    if [[ -f "$config" ]]; then
        echo "Found: $config"
    fi
done
COMMENT


: <<'COMMENT'
# --- while loop (used for retries — very common in DevOps) ---
echo "=== Health check with retry ==="
MAX_ATTEMPTS=5
ATTEMPT=1

while [[ $ATTEMPT -le $MAX_ATTEMPTS ]]; do
    echo "Health check attempt $ATTEMPT..."
    
    # Simulate checking if a service is up
    # In real scripts: curl -sf http://localhost:8080/health
    if [[ $ATTEMPT -eq 3 ]]; then    # simulate success on attempt 3
        echo "Service is healthy!"
        break
    fi
    
    echo "Service not ready, waiting..."
    sleep 1
    ((ATTEMPT++))
done

if [[ $ATTEMPT -gt $MAX_ATTEMPTS ]]; then
    echo "ERROR: Service failed to start after $MAX_ATTEMPTS attempts"
    exit 1
fi
COMMENT


: <<'COMMENT'
# --- until loop ---
COUNT=0
until [[ $COUNT -ge 3 ]]; do
    echo "Count: $COUNT"
    ((COUNT++))		# use ((++COUNT)) prefix increment so result is non-zero (avoids set -e exit on first iteration)
done
COMMENT


