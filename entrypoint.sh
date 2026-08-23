#!/usr/bin/env bash

set -euo pipefail

# Source all entrypoint scripts in lexicographic order
for script in /entrypoint.d/*.sh; do
    if [ -f "$script" ]; then
        if ! source "$script"; then
            echo "ERROR: $script failed. Dropping to shell." >&2
            exec bash
        fi
    fi
done

# Execute the command
exec "$@"
