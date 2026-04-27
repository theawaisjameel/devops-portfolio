#!/usr/bin/env bash
set -euo pipefail

# --- Create a temp file safely ---
TEMP_FILE=$(mktemp /tmp/deploy-XXXXXX.tmp)
LOCK_FILE="/tmp/$(basename "$0").lock"

# --- Cleanup function ---
cleanup() {
    local exit_code=$?
    echo "Cleaning up..."
    rm -f "$TEMP_FILE"
    rm -f "$LOCK_FILE"
    if [[ $exit_code -ne 0 ]]; then
        echo "Script failed with exit code: $exit_code"
    else
        echo "Script completed successfully"
    fi
}

# Register cleanup to run on EXIT (always), INT (Ctrl+C), TERM (kill)
trap cleanup EXIT INT TERM

# --- Prevent concurrent runs with a lock file ---
if [[ -f "$LOCK_FILE" ]]; then
    echo "ERROR: Another instance is already running (lock: $LOCK_FILE)"
    exit 1
fi
touch "$LOCK_FILE"

# --- Simulate work ---
echo "Working... (temp: $TEMP_FILE)"
echo "deployment data" > "$TEMP_FILE"
cat "$TEMP_FILE"

# Simulate an error halfway through
# Uncomment to test trap on error:
# false   # this command fails, triggering cleanup via set -e + EXIT trap

echo "Work done."
# cleanup runs automatically here via EXIT trap



# # ================== REVIEW: Missing Required Improvements ==================

# 1. Lock ownership is not tracked
#    → Current cleanup always deletes the lock file, even if this script did NOT create it.
#    → This can break another running instance.

# 2. No PID stored in lock file
#    → Lock file only indicates existence, not which process owns it.
#    → You cannot verify if the lock is still valid.

# 3. No stale lock handling
#    → If script crashes, lock file remains forever.
#    → Future runs will fail even though no process is running.

# 4. Race condition in lock creation
#    → Using: if [[ -f ]] + touch is NOT atomic.
#    → Two scripts starting at the same time can both pass the check and create the lock.

# 5. TEMP_FILE is created before acquiring lock
#    → If script exits early due to existing lock, temp file was unnecessarily created.

# 6. Cleanup removes files without checking existence
#    → rm -f is safe, but better practice is to check:
#      - variable is set
#      - file actually exists

# 7. Lock file is always deleted in cleanup
#    → Should only delete lock if it was created by THIS script instance.

# 8. No validation of lock file content
#    → Even if lock exists, it might be empty or corrupted.
#    → Script blindly trusts it.

# 9. No use of 'flock' (recommended for production)
#    → Manual lock files are error-prone.
#    → 'flock' provides atomic, kernel-level locking and avoids race conditions.

# ================================================================



# ================== REVIEW: Additional (Optional) Improvements ==================

# 10. TEMP_FILE variable not pre-initialized
#     → If script structure changes later, cleanup may reference an unset variable (with set -u).
#     → Safer to initialize: TEMP_FILE=""

# 11. Lock file path is fixed to /tmp
#     → Not flexible for environments where /tmp is restricted or cleaned aggressively.
#     → Could allow override via environment variable.

# 12. No retry mechanism for lock acquisition
#     → Script exits immediately if lock exists.
#     → In some cases, it may be better to wait and retry for a few seconds.

# 13. No clear separation between setup and execution logic
#     → Everything is in one flow.
#     → For larger scripts, splitting into functions improves readability and maintenance.

# 14. No explicit error messages for different failure types
#     → All failures look similar except exit code.
#     → More descriptive messages can help debugging in production.

# 15. No debug/logging mode
#     → Adding optional verbose mode (e.g., DEBUG=true) can help trace issues.

# 16. Use 'exec' with flock (if implemented)
#     → Ensures the lock is tied to the file descriptor lifecycle.
#     → Prevents accidental unlocking if subshells or child processes are used.

# 17. Ensure script runs with expected shell
#     → Even with shebang, some environments may invoke differently.
#     → Optional guard:
#       [[ -n "${BASH_VERSION:-}" ]] || { echo "Run with bash"; exit 1; }

# 18. Handle signals more explicitly if needed
#     → Current trap handles EXIT/INT/TERM, which is good.
#     → In strict systems, you might want different behavior per signal.

# 19. Avoid global namespace pollution (for large scripts)
#     → Wrap main logic in a function like: main()
#     → Then call: main "$@"
#     → Helps prevent variable conflicts in sourced environments.

# 20. Add basic input validation (if script later takes arguments)
#     → Not needed now, but important if script evolves.

# ================================================================

# With items 1–9 fixed, It’s safe and reliable.
# With everything (1–20), It’s fully production-grade, even in stricter environments.

# ================================================================


