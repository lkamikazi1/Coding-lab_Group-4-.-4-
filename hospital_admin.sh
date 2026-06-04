#!/bin/bash

#-------------------------------------------------
# Group 4 - hospital_admin.sh
# Member 1(Derrick): The Architect
# Member 2(Enzo): The Security Lead
# Member 3(Calvin): The Orchestrator
#--------------------------------------------------

#MEMBER 1: The Architect

initialize_system() {
    echo "Checking system directories..."

   
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


#MEMBER 2: The Security Lead

secure_data() {
    echo "Securing active_logs directory..."

    chmod 600 active_logs/*.log 2>/dev/null
    
    chown root active_logs/*.log 2>/dev/null

   
    echo "Current permissions on active_logs:"
    ls -l active_logs/
}


#MEMBER 3: The Orchestrator

echo "Starting System Setup..."
initialize_system
secure_data
echo "System Environment Secured - $(date)"
