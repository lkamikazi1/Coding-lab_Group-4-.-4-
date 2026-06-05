#!/bin/bash
#-------------------------------------------
# KNH Hospital Admin Script
# Members 1 (Derrick): The architect
#Member 2 (Enzo): The security lead
#Member 3 (Calvin): The orchestrator
#--------------------------------------------

# MEMBER 1: The Architect
initialize_system() {
    if [ ! -d "active_logs" ]; then
        mkdir active_logs
        echo "Creating active_logs directory..."
    else
        echo "active_logs already exists."
    fi
    if [ ! -d "archived_logs" ]; then
        mkdir archived_logs
        echo "Creating archived_logs directory..."
    else
        echo "archived_logs already exists."
    fi
    if [ ! -d "reports" ]; then
        mkdir reports
        echo "Creating reports directory..."
    else
        echo "reports already exists."
    fi
    echo "System directories are ready."
}

# MEMBER 2: The Security Lead
secure_data() {
    echo "============================================"
    echo "  [Member 2] Running Security Configuration"
    echo "============================================"
    if [ ! -d "active_logs" ]; then
        echo "[ERROR] active_logs not found. Run initialize_system() first."
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

# MEMBER 3: The Orchestrator
main(){
echo "Starting System Setup..."
    initialize_system || { echo "ERROR: Setup failed. Exiting."; exit 1; }
    secure_data || { echo "ERROR: Security config failed. Exiting."; exit 1; }
    echo "System Environment Secured - $(date)"
    mkdir -p reports
    echo "$(date): System secured by hospital_admin.sh" >> reports/admin_run.log
}

main
