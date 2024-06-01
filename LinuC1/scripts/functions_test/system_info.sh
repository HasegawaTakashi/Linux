#!/bin/bash

# Define the path of the log file
LOG_FILE="/home/takashi-hasegawa6/src/Linux/LinuC1/scripts/functions_test/logs/system_info.log"

# Define the path of the error log file
ERROR_LOG_FILE="/home/takashi-hasegawa6/src/Linux/LinuC1/scripts/functions_test/logs/system_info_error.log"

# Function to get the current date and time
get_datetime() {
    date +"%Y-%m-%d %H:%M:%S %Z %z"
}

# Function to get system information
get_system_info() {
    echo -e "\n---- System Information ----"
    echo "Date and Time: $(get_datetime)"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "Kernel Version: $(uname -r)"
    echo "OS Version: $(lsb_release -d | cut -f2-)"
    echo "Memory Usage:"
    free -h
    echo "Disk Usage:"
    df -h
    echo "Top Processes:"
    ps aux --sort=-%mem | head -10
    echo "----------------------------"
}

# Function to write system information to the log file
write_log() {
    get_system_info >> "$LOG_FILE" 2>> "$ERROR_LOG_FILE"
}

# Main function
main() {
    if [[ $(id -u) -ne 0 ]]; then
        echo "Error: This script must be run as root." | tee -a "$ERROR_LOG_FILE"
        exit 1
    fi

    echo "Collecting system information..."
    if write_log; then
        echo "System information successfully written to $LOG_FILE"
    else
        echo "Error: Failed to write system information to $LOG_FILE" | tee -a "$ERROR_LOG_FILE"
        exit 1
    fi
}

# Execute the script
main
