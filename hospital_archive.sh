#!/bin/bash

#--------------------------------------------------------------------------------------------------
# KNH Hospital Admin Script
# Member 4 (Lizza): The archivist
#---------------------------------------------------------------------------------------------------

archive_logs() {
    if [ ! -d "active_logs" ]; then
        echo "No active_logs directory found. Exiting."
        exit 1
    fi


    if [ ! -d "archived_logs" ]; then
        mkdir archived_logs
        echo "Creating archived_logs directory..."
    fi

   
    TIMESTAMP=$(date +%Y%m%d_%H%M)

   
    for log in active_logs/*.log; do
        if [ -f "$log" ]; then
            FILENAME=$(basename "$log" .log)
            mv "$log" "archived_logs/${FILENAME}_${TIMESTAMP}.log"
            echo "Archived: ${FILENAME}_${TIMESTAMP}.log"
        fi
    done

   
    touch active_logs/heart_rate_log.log
    touch active_logs/temperature_log.log
    touch active_logs/water_usage_log.log
    echo "Fresh log files created in active_logs/"

    echo "Archiving complete!"
}

archive_logs


