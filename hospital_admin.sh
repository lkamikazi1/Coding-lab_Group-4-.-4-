#!/bin/bash

secure_data() {
    echo "============================================"
    echo "  [Member 2] Running Security Configuration"
    echo "============================================"

    if [ ! -d "active_logs" ]; then
        echo "[ERROR] active_logs directory not found."
        return 1
    fi

    echo "[INFO] Applying security permissions to active_logs..."
    chmod 600 active_logs
    echo "[INFO] Permissions applied successfully."
    echo ""
    echo "[INFO] Current permissions for active_logs:"
    ls -l | grep active_logs
    echo ""
    echo "[SUCCESS] active_logs is now secured - Owner access only."
    echo ""
}
