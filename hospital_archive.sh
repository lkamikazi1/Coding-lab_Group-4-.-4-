#!/bin/bash

archive_logs() {
	if [ ! -d "active_logs" ]; then
		echo "No active_logs directory found."
		exit 1 

	fi

	if [ ! -d "archived_logs" ]; then
		mkdir archived_logs
		echo "Creating archived_logs directory.."
	fi

	TIMESTAMP=$(date +%Y%m%d_%H%M)

	for log in active_logs/*.log; do
		if [ -f "$log" ]; then
			FILENAME-$(basename "$log" .log)
			mv "$log" "archive_logs/${FILENAME}_${TIMESTAMP}.log"
			echo "Archived: ${FILENAME}_${TIMESTAMP}.log"
		fi
	done 

	touch active_logs/heart_rate.log
	touch active_logs/temperature.log
	touch active_logs/ICU_WATER_RESERVE.log
	echo "Fresh log files created in active_logs/"

	echo "Archiving complete!"

} 
