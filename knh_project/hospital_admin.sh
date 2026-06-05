#!/bin/bash

# Group 4- Member 1 _ the architect
# Function: Initialize_system
# Purporse: Creates the required directories if they dont exist.

initialize_system() {
	echo "Initializing KNH system environment..."
    if [ ! -d "active_logs" ]; then	    
       echo "Creating active_logs directory..."
        mkdir active_logs
    fi
    if [ ! -d "archived_logs" ]; then
        echo "Creating archived_logs directory..."
        mkdir archived_logs
    fi
    if [ ! -d "reports" ]; then
        echo "Creating reports directory..."
        mkdir reports
    fi
}
 echo "system directories are ready"


initialize_system
